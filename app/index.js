'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


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

  // // welcome message
  // var welcome =
  // '\n     _-----_' +
  // '\n    |       |' +
  // '\n    |' + '--(o)--'.red + '|   .--------------------------.' +
  // '\n   `---------´  |    ' + 'Welcome to Yeoman,'.yellow.bold + '    |' +
  // '\n    ' + '( '.yellow + '_' + '´U`'.yellow + '_' + ' )'.yellow + '   |   ' + 'ladies and gentlemen!'.yellow.bold + '  |' +
  // '\n    /___A___\\   \'__________________________\'' +
  // '\n     |  ~  |'.yellow +
  // '\n   __' + '\'.___.\''.yellow + '__' +
  // '\n ´   ' + '`  |'.red + '° ' + '´ Y'.red + ' `\n';

  // console.log(welcome);

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

DefaultGenerator.prototype.app = function app() {
  console.log(this)
  // this.mkdir('js');
  // this.mkdir('js/models');
  // this.mkdir('js/collections');
  // this.mkdir('js/views');
  // this.mkdir('js/routers');
  // this.mkdir('js/lib');
  // this.mkdir('html');
  // this.mkdir('css');
  // this.mkdir('images');


  // this.template('bower.json', 'bower.json');
  // this.template('package.json', 'package.json');
  
  // this.template('index.jade', 'index.jade');

  // this.template('css/main.styl', 'css/main.styl');
  
  // this.template('js/main.coffee', 'js/main.coffee');
  // this.template('js/app.coffee', 'js/app.coffee');
  // this.template('js/routers/main.coffee', 'js/routers/main.coffee');
  // this.template('js/models/base.coffee', 'js/models/base.coffee');

  // this.copy('_bowerrc', '.bowerrc');

  // this.installDependencies();
};


// DefaultGenerator.prototype.projectfiles = function projectfiles() {
//   // this.copy('editorconfig', '.editorconfig');
//   // this.copy('jshintrc', '.jshintrc');
// };
