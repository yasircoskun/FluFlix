module.exports = {
    entry: {
        // This index.js is main file which should include all other modules 
        app: ['./Scripts/index.js']
    },
    output: {
        // this says : Compiled file goes to [name].js ie. app.js in my case
        path: __dirname + "/wwwroot/js/dist/",
        filename: '[name].js'
    },
    devtool: 'source-map',
    module: {
        // modules contains Special compilation rules 
        rules: [{ // Ask webpack to check: If this file ends with .js, then apply some transforms
                test: /\.js$/,
                // don't transform node_modules folder  this folder need not to be compiled and not needed at production mode
                exclude: /node_modules/,
                // load this .js file using babel loader so as to make it compactible with any browser
                loader: 'babel-loader'
            },
            { test: /\.(png|woff|woff2|eot|ttf|svg)$/ },
            {
                // Ask webpack to check: If this file ends with .css, then apply some transforms 
                test: /\.css$/,
                use: [ //  use css loader to load css file
                    { loader: "css-loader" }
                ]
            }
        ]
    }
};