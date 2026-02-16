module.exports = {
  default: {
    paths: ['features/*.feature'],
    requireModule: ['ts-node/register'],
    require: ['steps/*.steps.ts', 'support/*.ts'],
    format: ['progress-bar', 'summary', 'html:cucumber-report.html'],
    publishQuiet: true
  }
}
