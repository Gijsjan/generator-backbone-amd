# Generator for Yeoman 
Scaffolds an app with Backbone.js, Require.js and Mocha-phantomjs testing.

## Get the generator
- git clone https://github.com/Gijsjan/generator-backbone-amd.git
- cd generator-backbone-amd
- sudo npm link

## Run the generator
- mkdir ~/my_app
- cd ~/my_app
- yo backbone-amd

## Check if Mocha tests work in the browser (tests in .test/tests.js)
- npm start
- Browse to 0.0.0.0:8000/.test/index.html

## Check if Mocha works in the browser and the console (tests in test/*.coffee)
- grunt watch
- edit a .coffee file in /test
- Browse to 0.0.0.0:8000/.test/index.html


