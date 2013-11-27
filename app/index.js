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
	this.copy('_groc.json', '.groc.json');
	this.copy('Gruntfile.coffee', 'Gruntfile.coffee');
	this.copy('server.coffee', 'server.coffee');

	this.template('bower.json', 'bower.json');
	this.template('package.json', 'package.json');
};