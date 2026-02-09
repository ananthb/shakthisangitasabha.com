import fs from 'fs';

function jsonExtractor(content) {
  const els = JSON.parse(content).htmlElements;
  return [...(els.tags || []), ...(els.classes || []), ...(els.ids || [])];
}

const isProd = process.env.HUGO_ENVIRONMENT === 'production';
const statsExist = fs.existsSync('./hugo_stats.json');

export default {
  plugins: {
    ...(isProd && statsExist ? {
      '@fullhuman/postcss-purgecss': {
        content: ["./hugo_stats.json", "./assets/js/**/*.js"],
        extractors: [
          {
            extractor: jsonExtractor,
            extensions: ["json"]
          }
        ],
        safelist: [],
      }
    } : {}),
    cssnano: isProd ? { preset: 'default' } : false
  }
};
