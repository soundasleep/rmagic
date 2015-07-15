module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')

    clean:
      css: ['public/css/*.css']
      js: ['public/js/*.js']

    sass:
      dist:
        files: [{
          expand: true
          cwd: 'public/stylesheets'
          src: ['**/*.scss']
          dest: 'public/css'
          ext: '.css'
        }]

    coffee:
      dist:
        files: [{
          expand: true
          cwd: 'public/javascripts'
          src: ['**/*.coffee']
          dest: 'public/js/generated'
          ext: '.js'
        }]

    spritify:
      dist:
        options:
          input: 'public/css/default.css',
          output: 'public/css/default.css',
          png: 'public/images/sprites.png'

    browserify:
      options:
        transform: ['babelify']
      dist:
        src: 'public/js/generated/**/*.js'
        dest: 'public/js/compiled.js'

    watch:
      styles:
        files: ['public/**/*.scss']
        tasks: ['sass', 'spritify']

      scripts:
        files: ['public/**/*.coffee']
        tasks: ['coffee', 'browserify']

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-spritify'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', "Generate static sites and assets", [
    'clean',
    'sass',
    'coffee',
    'browserify',
    'spritify'
  ]

  grunt.registerTask 'serve', [
    'default',
    'watch'
  ]
