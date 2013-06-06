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

var base = 'dev/';

DefaultGenerator.prototype.createBase = function app() {

	this.mkdir('test');
	this.template('test/body.coffee', 'test/body.coffee');

	this.mkdir(base);
	this.mkdir(base + 'html');
	this.mkdir(base + 'css');
	this.mkdir(base + 'images');
	this.mkdir(base + 'js');
	this.mkdir(base + 'js/routers');
	this.mkdir(base + 'js/models');
	this.mkdir(base + 'js/collections');
	this.mkdir(base + 'js/views');
	this.mkdir(base + 'js/managers');

	this.template('_bowerrc', '.bowerrc');
	this.template('bower.json', 'bower.json');
	this.template('package.json', 'package.json');
	this.template('Gruntfile.coffee', 'Gruntfile.coffee');
};

DefaultGenerator.prototype.createMarkup = function app() {
	this.template(base+'index.jade', base+'index.jade');
	this.template(base+'css/main.styl', base+'css/main.styl');
};

DefaultGenerator.prototype.createJS = function app() {
	this.template(base+'js/main.coffee', base+'js/main.coffee');
	this.template(base+'js/app.coffee', base+'js/app.coffee');
	this.template(base+'js/config.coffee', base+'js/config.coffee');
	this.template(base+'js/pubsub.coffee', base+'js/pubsub.coffee');

	this.template(base+'js/routers/main.coffee', base+'js/routers/main.coffee');

	this.template(base+'js/models/base.coffee', base+'js/models/base.coffee');
	this.template(base+'js/models/currentUser.coffee', base+'js/models/currentUser.coffee');

	this.template(base+'js/collections/base.coffee', base+'js/collections/base.coffee');
};

// ADD helpers & managers using Grunt
