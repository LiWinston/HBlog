module.exports = {
	devServer: {
		port: 12092,
		open: true,
		overlay: {
			warnings: false,
			errors: true
		},
		disableHostCheck: true,
	},
	configureWebpack: {
		resolve: {
			alias: {
				'assets': '@/assets',
				'common': '@/common',
				'components': '@/components',
				'api': '@/api',
				'views': '@/views',
				'plugins': '@/plugins'
			}
		},
		optimization: {
			splitChunks: {
				cacheGroups: {
					vendor: {
						test: /[\\/]node_modules[\\/]/,
						name(module) {
							const packageName = module.context.match(
								/[\\/]node_modules[\\/](.*?)([\\/]|$)/
							)[1];
							return `npm.${packageName.replace("@", "")}`;
						},
						chunks: "all",
						enforce: true,
						priority: 10,
						minSize: 50000, // 50KB
						maxSize: 200000,
						reuseExistingChunk: true,
					},
				},
			},
		}
	}
}