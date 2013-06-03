'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');
var fs = require('fs');


var DefaultGenerator = module.exports = function DefaultGenerator(args, options, config) {
	yeoman.generators.Base.apply(this, arguments);

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

DefaultGenerator.prototype.create = function app() {
	this.template('_bowerrc', '.bowerrc');
	this.template('bower.json', 'bower.json');
	this.template('package.json', 'package.json');

	this.mkdir('html');
	this.template('index.jade', 'index.jade');

	this.mkdir('css');
	this.template('css/main.styl', 'css/main.styl');

	this.mkdir('images');
};

DefaultGenerator.prototype.createJS = function app() {
	this.mkdir('js');
	this.template('js/main.coffee', 'js/main.coffee');
	this.template('js/app.coffee', 'js/app.coffee');
	this.template('js/config.coffee', 'js/config.coffee');
	this.template('js/pubsub.coffee', 'js/pubsub.coffee');
	
	this.mkdir('js/routers');
	this.template('js/routers/main.coffee', 'js/routers/main.coffee');

	this.mkdir('js/models');
	this.template('js/models/base.coffee', 'js/models/base.coffee');
	this.template('js/models/currentUser.coffee', 'js/models/currentUser.coffee');

	this.mkdir('js/collections');
	this.template('js/collections/base.coffee', 'js/collections/base.coffee');

	this.mkdir('js/views');

	this.mkdir('js/managers');
};

// DefaultGenerator.prototype.projectfiles = function projectfiles() {
//   // this.copy('editorconfig', '.editorconfig');
//   // this.copy('jshintrc', '.jshintrc');
// };
