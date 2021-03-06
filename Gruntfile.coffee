module.exports = (grunt)->
	grunt.initConfig
		pkg: grunt.file.readJSON('package.json')
		clean:
			all: ['lib/']
			html: ['src/client/*html']
		coffee:
			src:
				files:
					'lib/s3age.js': [
						'src/detector.coffee'
						'src/stats.coffee'
						'src/stage.coffee'
						'src/debug.coffee'
						'src/clock.coffee'
						'src/camera.coffee'
						'src/renderer.coffee'
						'src/click.coffee'
						'src/loader.coffee'
					],
					'lib/s3age.controls.js': [
						'src/extend.coffee'
						'src/controls/Controls.coffee'
						'src/controls/Trackball.coffee'
						'src/controls/Chase.coffee'
						'src/controls/FirstPerson.coffee'
					]
				options:
					bare: true
		watch:
			client:
				files: ['src/**/*coffee']
				tasks: ['build']

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-watch'

	grunt.registerTask 'build-client', ['coffee:src']
	grunt.registerTask 'build', ['build-client']
	grunt.registerTask 'tests', []
	grunt.registerTask 'default', ['clean', 'build']
