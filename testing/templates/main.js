require.config({
	baseUrl: '/.test/',
	paths: {
		mocha: '../dev/js/lib/mocha/mocha',
		chai: '../dev/js/lib/chai/chai'
		// jquery: 'lib/jquery-1.9.1'
	}
});

require(['require', 'mocha'], function(require)  {
	mocha.setup('bdd');

	require(['/.test/tests.js'], function() {
		if (window.mochaPhantomJS) { mochaPhantomJS.run(); }
		else { mocha.run(); }
	});
});