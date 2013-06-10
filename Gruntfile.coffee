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
						'src/stage.coffee'
						'src/camera.coffee'
						'src/renderer.coffee'
						'src/click.coffee'
					]
				options:
					bare: true
		watch:
			client:
				files: [
					'src/*coffee'
				],
				tasks: ['build']

	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-clean'
	grunt.loadNpmTasks 'grunt-contrib-watch'

	grunt.registerTask 'build-client', ['coffee:src']
	grunt.registerTask 'build', ['build-client']
	grunt.registerTask 'tests', []
	grunt.registerTask 'default', ['clean', 'build']
