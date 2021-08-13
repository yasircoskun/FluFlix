module.exports = {
    devServer: {
        proxy: {
            '^/graphql': {
                target: 'https://localhost:5001',
                changeOrigin: true
            },
        }
    }
}