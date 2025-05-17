const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const CssMinimizerPlugin = require('css-minimizer-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const fs = require('fs');

// Create default book cover images if they don't exist
const staticImagesDir = path.resolve(__dirname, 'static/images');
if (!fs.existsSync(staticImagesDir)) {
  fs.mkdirSync(staticImagesDir, { recursive: true });
}

const bookCovers = [
  'book-cover.jpg', 'book-cover2.jpg', 'book-cover3.jpg', 
  'book-cover4.jpg', 'book-cover5.jpg'
];

bookCovers.forEach(cover => {
  const coverPath = path.join(staticImagesDir, cover);
  if (!fs.existsSync(coverPath)) {
    // Create an empty file
    fs.writeFileSync(coverPath, '');
  }
});

module.exports = (env, options) => {
  const devMode = options.mode !== 'production';

  return {
    optimization: {
      minimizer: [
        new TerserPlugin({
          parallel: true,
        }),
        new CssMinimizerPlugin()
      ]
    },
    entry: {
      'app': glob.sync('./vendor/**/*.js').concat(['./js/app.js'])
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/'
    },
    devtool: devMode ? 'source-map' : false,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env']
            }
          }
        },
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            {
              loader: 'css-loader',
              options: {
                url: true,
                import: true,
              }
            },
            'sass-loader',
          ],
        },
        {
          test: /\.(woff(2)?|ttf|eot|svg)(\?v=\d+\.\d+\.\d+)?$/,
          use: [
            {
              loader: 'file-loader',
              options: { name: '[name].[ext]', outputPath: '../fonts' }
            },
          ],
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: '../css/app.css' }),
      new CopyWebpackPlugin({ 
        patterns: [
          { 
            from: 'static/',
            to: '../',
            globOptions: {
              dot: true,
              gitignore: true,
              ignore: ['**/.DS_Store', '**/.gitkeep'],
            },
          }
        ]
      })
    ]
  }
};
