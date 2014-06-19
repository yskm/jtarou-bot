module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    typescript: {
      base: {
        src: ['scripts/**/*.ts'],
        options: {
          watch: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-typescript');

  grunt.registerTask( 'default', [ 'typescript' ] );
};