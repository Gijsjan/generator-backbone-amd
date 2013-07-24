'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var TestingGenerator = module.exports = function TestingGenerator(args, options, config) {
	yeoman.generators.Base.apply(this, arguments);

	console.log('You called the testing subgenerator with the argument ' + this.name + '.');
};

util.inherits(TestingGenerator, yeoman.generators.Base);

TestingGenerator.prototype.files = function files() {
	this.directory('_test', '.test')
	this.directory('test', 'test')
	// this.mkdir('.test');
	// this.mkdir('.test/bin');

	// this.mkdir('test');
	// this.template('test/body.coffee', 'test/body.coffee');

	// this.template('index.html', '.test/index.html');
	// this.template('main.js', '.test/main.js');
	// this.template('tests.js', '.test/tests.js');
	// this.template('head.coffee', '.test/head.coffee');
	// this.template('template.coffee', '.test/template.coffee');

	// this.template('bin/server.js', '.test/bin/server.js');
};
