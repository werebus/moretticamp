const { environment } = require('@rails/webpacker')
const MomentLocalesPlugin = require('moment-locales-webpack-plugin'); 
const webpack = require('webpack');

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery'
}));
environment.plugins.append('MomentLocales', new MomentLocalesPlugin());

module.exports = environment
