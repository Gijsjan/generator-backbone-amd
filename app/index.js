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
		this.installDependencies({ skipInstall: options['skip-install'] });
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

	this.mkdir('dev');
	this.mkdir('dev/html');
	this.mkdir('dev/css');
	this.mkdir('dev/images');
	this.mkdir('dev/js');
	
	this.mkdir('src');
	this.mkdir('src/jade');
	this.mkdir('src/stylus');
	this.mkdir('src/coffee/routers');
	this.mkdir('src/coffee/models');
	this.mkdir('src/coffee/collections');
	this.mkdir('src/coffee/views');
	this.mkdir('src/coffee/managers');

	this.mkdir('test');
	this.template('test/body.coffee', 'test/body.coffee');

	this.template('_bowerrc', '.bowerrc');
	this.template('bower.json', 'bower.json');
	this.template('package.json', 'package.json');
	this.template('Gruntfile.coffee', 'Gruntfile.coffee');
	this.template('server.coffee', 'server.coffee');
};

DefaultGenerator.prototype.createMarkup = function app() {
	this.template('src/index.jade', 'src/index.jade');
	this.template('src/stylus/main.styl', 'src/stylus/main.styl');
};

DefaultGenerator.prototype.createJS = function app() {
	this.template('src/coffee/main.coffee', 'src/coffee/main.coffee');
	this.template('src/coffee/app.coffee', 'src/coffee/app.coffee');
	this.template('src/coffee/config.coffee', 'src/coffee/config.coffee');
	this.template('src/coffee/pubsub.coffee', 'src/coffee/pubsub.coffee');

	this.template('src/coffee/routers/main.coffee', 'src/coffee/routers/main.coffee');

	this.template('src/coffee/models/base.coffee', 'src/coffee/models/base.coffee');
	this.template('src/coffee/models/currentUser.coffee', 'src/coffee/models/currentUser.coffee');

	this.template('src/coffee/collections/base.coffee', 'src/coffee/collections/base.coffee');
};

// ADD helpers & managers using Grunt
