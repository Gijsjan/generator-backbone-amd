'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');

var DefaultGenerator = module.exports = function DefaultGenerator(args, options, config) {
	yeoman.generators.Base.apply(this, arguments);

	// console.log(this);
	this.hookFor('backbone-amd:testing', {
		args: args,
		options: options
	});

	this.on('end', function () {
		this.installDependencies();
	});

	this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(DefaultGenerator, yeoman.generators.Base);

DefaultGenerator.prototype.askFor = function askFor() {
	var cb = this.async();

	var prompts = [{
		name: 'projectName',
		message: 'What is the name of the project?',
	}];

	this.prompt(prompts, function (err, props) {
		if (err) {
			return this.emit('error', err);
		}

		this.projectName = props.projectName;

		cb();
	}.bind(this));
};

DefaultGenerator.prototype.createBase = function app() {
	this.directory('src', 'src');
	this.mkdir('compiled');
	this.mkdir('dist');
	this.mkdir('images');

	this.copy('_bowerrc', '.bowerrc');
	this.copy('Gruntfile.coffee', 'Gruntfile.coffee');
	this.copy('server.coffee', 'server.coffee'); // Remove to use grunt server

	this.template('bower.json', 'bower.json');
	this.template('package.json', 'package.json');
}	
// DefaultGenerator.prototype.createBase = function app() {
// 	this.mkdir('dev');
// 	this.mkdir('dev/html');
// 	this.mkdir('dev/css');
// 	this.mkdir('dev/images');
// 	this.mkdir('dev/js');
	
// 	this.mkdir('src');
// 	this.mkdir('src/jade');
// 	this.mkdir('src/stylus');
// 	this.mkdir('src/coffee/routers');
// 	this.mkdir('src/coffee/models');
// 	this.mkdir('src/coffee/collections');
// 	this.mkdir('src/coffee/views');
// 	this.mkdir('src/coffee/managers');

// 	this.mkdir('stage');

// 	this.template('_bowerrc', '.bowerrc');
// 	this.template('bower.json', 'bower.json');
// 	this.template('package.json', 'package.json');
// 	this.template('Gruntfile.coffee', 'Gruntfile.coffee');
// 	this.template('server.coffee', 'server.coffee');
// };

// DefaultGenerator.prototype.createMarkup = function app() {
// 	this.template('src/index.jade', 'src/index.jade');
// 	this.template('src/jade/home.jade', 'src/jade/home.jade');
// };

// DefaultGenerator.prototype.createStylus = function app() {
// 	this.template('src/stylus/main.styl', 'src/stylus/main.styl');
// 	this.template('src/stylus/layout.styl', 'src/stylus/layout.styl');
// };

// DefaultGenerator.prototype.createJS = function app() {
// 	this.template('src/coffee/main.coffee', 'src/coffee/main.coffee');
// 	this.template('src/coffee/app.coffee', 'src/coffee/app.coffee');
// 	this.template('src/coffee/config.coffee', 'src/coffee/config.coffee');
// 	this.template('src/coffee/pubsub.coffee', 'src/coffee/pubsub.coffee');

// 	this.template('src/coffee/routers/main.coffee', 'src/coffee/routers/main.coffee');

// 	this.template('src/coffee/models/base.coffee', 'src/coffee/models/base.coffee');
// 	this.template('src/coffee/models/currentUser.coffee', 'src/coffee/models/currentUser.coffee');

// 	this.template('src/coffee/collections/base.coffee', 'src/coffee/collections/base.coffee');
// 	this.template('src/coffee/collections/view.coffee', 'src/coffee/collections/view.coffee');

// 	this.template('src/coffee/views/base.coffee', 'src/coffee/views/base.coffee');
// 	this.template('src/coffee/views/home.coffee', 'src/coffee/views/home.coffee');

// 	this.template('src/coffee/managers/cookie.coffee', 'src/coffee/managers/cookie.coffee');
// 	this.template('src/coffee/managers/view.coffee', 'src/coffee/managers/view.coffee');
// };

// ADD helpers & managers using Grunt
