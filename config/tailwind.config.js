const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      colors: {
        // Primary Colors
        'christi': '#64b40c',
        'limeade': '#468204',
        'van-cleef': '#420d0e',
        'black': '#040404',
        // Accent Colors
        'bright-green': '#71d604',
        'tamarillo': '#a51611',
        'new-york-pink': '#d98186',
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography'),
  ]
}
