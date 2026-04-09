import { Before, After, setDefaultTimeout, Status } from "@cucumber/cucumber";
import * as fs from "fs";
import { chromium } from "@playwright/test";
import { CustomWorld } from "./world";

setDefaultTimeout(60 * 1000);

Before(async function (this: CustomWorld) {
  this.browser = await chromium.launch({ headless: true });
  const context = await this.browser.newContext();
  this.page = await context.newPage();
});

After(async function (this: CustomWorld, scenario) {
  if (scenario.result?.status === Status.FAILED) {
    const screenshot = await this.page?.screenshot({ path: "screenshot.png" });
    if (screenshot) {
      await this.attach(screenshot, "image/png");
    }
    const html = await this.page?.content();
    fs.writeFileSync("page_dump.html", html || "");
  }
  await this.browser?.close();
});
