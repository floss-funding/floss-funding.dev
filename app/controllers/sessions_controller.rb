class SessionsController < ApplicationController
  protect_from_forgery except: [:omniauth]

  def new
    # Promote query param alerts/notices into flash.now so the layout renders them.
    if params[:alert].present? && flash[:alert].blank?
      flash.now[:alert] = params[:alert]
    end
    if params[:notice].present? && flash[:notice].blank?
      flash.now[:notice] = params[:notice]
    end
  end

  # Fallback handler for initiating OmniAuth when provider middleware isn't mounted.
  # Security: does not start OAuth itself; only redirects with a helpful message if misconfigured.
  def omniauth_start
    provider = params[:provider].to_s

    providers = Rails.configuration.x.oauth_providers || {}
    configured = providers[provider]

    unless configured
      redirect_to(new_session_path, alert: "#{provider.titleize} sign-in is not configured. Please try again later.", status: 303) and return
    end

    # If configured, this action shouldn't normally run because OmniAuth middleware handles it earlier.
    # But as a safe fallback, guide the user.
    redirect_to(new_session_path, alert: "Please use the Sign in with #{provider.titleize} button to start authentication.", status: 303)
  end

  # Password sign-in (Identity)
  def create
    identity = Identity.find_by(email: params[:email])
    if identity&.authenticate(params[:password])
      session[:account_id] = identity.account_id
      redirect_to(activation_keys_path, notice: "Signed in successfully", status: :see_other)
    else
      flash.now[:alert] = "Invalid email or password"
      render(:new, status: :unprocessable_entity)
    end
  end

  # OmniAuth callback for external providers
  def omniauth
    auth = request.env["omniauth.auth"]
    if auth.blank?
      redirect_to(new_session_path, alert: "Authentication failed: missing data", status: :see_other) and return
    end

    email = auth.dig("info", "email")
    name = auth.dig("info", "name") || auth.dig("info", "nickname")

    if email.blank?
      redirect_to(new_session_path, alert: "Authentication succeeded but no email was provided. Please ensure email scope is granted and public/primary email is set.", status: :see_other) and return
    end

    account = Account.find_or_create_by!(email: email) do |acc|
      # In the future we could store name/avatar. For now Account only has email.
    end

    session[:account_id] = account.id
    redirect_to(activation_keys_path, notice: "Signed in as #{name || email}", status: :see_other)
  rescue StandardError => e
    Rails.logger.error("OmniAuth error: #{e.class}: #{e.message}")
    redirect_to(new_session_path, alert: "Authentication failed", status: :see_other)
  end

  def failure
    message = params[:message].presence || "Unknown error"
    redirect_to(new_session_path, alert: "Authentication failed: #{message}", status: :see_other)
  end

  def destroy
    reset_session
    redirect_to(root_path, notice: "Signed out", status: :see_other)
  end
end
