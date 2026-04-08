module.exports = {
  default: {
    paths: ["features/*.feature"],
    requireModule: ["ts-node/register"],
    require: ["src/steps/*.steps.ts", "src/support/*.ts"],
    format: ["progress-bar", "summary", "html:cucumber-report.html"],
    publishQuiet: true,
  },
};
