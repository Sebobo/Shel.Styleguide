module.exports = (grunt) ->
  'use strict'

  pngcrush = require 'imagemin-pngcrush'
  jpegRecompress = require 'imagemin-jpeg-recompress'

  # Load necessary plugins
  grunt.loadNpmTasks 'grunt-contrib-compass'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-contrib-imagemin'
  grunt.loadNpmTasks 'grunt-newer'
  grunt.loadNpmTasks 'assemble'

  grunt.initConfig
    dirs:
      private: 'Resources/Private'
      public: 'Resources/Public'
      styleguide: '<%= dirs.private %>/Styleguide'
      src:
        sass: '<%= dirs.private %>/Styles'
        bower: '<%= dirs.private %>/BowerComponents'
        assets: '<%= dirs.private %>/UnprocessedAssets'
        partials: '<%= dirs.styleguide %>/Partials'
        layouts: '<%= dirs.styleguide %>/Layouts'
        data: '<%= dirs.styleguide %>/Data'
        site: '<%= dirs.styleguide %>/Site'
      dest:
        css: '<%= dirs.public %>/Styles'
        assets: '<%= dirs.public %>/Images'
        fonts: '<%= dirs.public %>/Fonts'
    compass:
      dist:
        options:
          config: 'config.rb'
    imagemin:
      dynamic:
        options:
          optimizationLevel: 7
          use: [
            jpegRecompress
              quality: 'high'
              max: 90
            pngcrush
              reduce: true
          ]
        files: [{
          expand: true
          cwd: '<%= dirs.src.assets %>'
          src: ['*.{png,jpg,gif}']
          dest: '<%= dirs.dest.assets %>'
        }]
    watch:
      sass:
        files: ['<%= dirs.src.sass %>/**/*.scss']
        tasks: ['styles']
      assets:
        files: ['<%= dirs.src.assets %>/**/*.{png,jpg,gif}']
        tasks: ['imagemin']
      styleguide:
        files: ['<%= dirs.styleguide %>/**/*.hbs']
        tasks: ['assemble']
    autoprefixer:
      dist:
        src: '<%= dirs.dest.css %>/App.pre.css'
        dest: '<%= dirs.dest.css %>/App.dist.css'
    assemble:
      options:
        flatten: true
        assets: '<%= dirs.src.assets %>'
        plugins: ['permalinks']
        partials: ['<%= dirs.src.partials %>/**/*.hbs']
        layoutdir: '<%= dirs.src.layouts %>'
        layout: ['Default.hbs']
        data: ['<%= dirs.src.data %>/*.{json,yml}']
      site:
        src: ['<%= dirs.src.site %>/*.hbs']
        dest: '<%= dirs.public %>/Styleguide/'

  grunt.registerTask 'default', ['build', 'watch']
  grunt.registerTask 'styles', ['compass', 'newer:autoprefixer']
  grunt.registerTask 'build', ['styles', 'newer:imagemin', 'assemble']
