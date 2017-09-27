module.exports = {
	entry: './index.coffee',
	output: {
		path: __dirname + '/build',
		filename: 'joystick.coffee'
	},
	module: {
		rules: [
			{
				test: /\.coffee$/,
				use: [ 'coffee-loader' ]
			}
		]
	}
}