function jsonExtractor(content) {
  const els = JSON.parse(content).htmlElements;
  return [...(els.tags || []), ...(els.classes || []), ...(els.ids || [])];
}

export default {
  plugins: {
    '@fullhuman/postcss-purgecss': {
      content: ["./hugo_stats.json", "./assets/js/**/*.js"],
      extractors: [
        {
          extractor: jsonExtractor,
          extensions: ["json"]
        }
      ],
      safelist: [],
    },
    cssnano: { preset: 'default' }
  }
};
