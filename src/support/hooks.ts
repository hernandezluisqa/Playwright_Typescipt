import {
  Before,
  After,
  setDefaultTimeout,
  Status,
  BeforeAll,
} from "@cucumber/cucumber";
import * as fs from "node:fs";
import { chromium } from "@playwright/test";
import { CustomWorld } from "./world";
import { TransferenciaPage } from "../pages/TransferenciaPage";
import { ProfilePage } from "../pages/ProfilePage";
import { SideBarPage } from "../pages/SideBarPage";
import { LoginPage } from "../pages/LoginPage";
import path from "node:path";

setDefaultTimeout(60 * 1000);

BeforeAll(() => {
  const files = fs.readdirSync(process.cwd());

  files.forEach((file) => {
    if (file.startsWith("screenshot-") || file.startsWith("page_dump-")) {
      fs.unlinkSync(path.join(process.cwd(), file));
    }
  });
});

Before(async function (this: CustomWorld) {
  this.browser = await chromium.launch({ headless: true });
  const context = await this.browser.newContext();
  this.page = await context.newPage();

  if (!this.page) throw new Error("Page no inicializada");
  this.transferenciaPage = new TransferenciaPage(this.page);
  this.profilePage = new ProfilePage(this.page);
  this.sideBarPage = new SideBarPage(this.page);
  this.loginPage = new LoginPage(this.page);
});

After(async function (this: CustomWorld, scenario) {
  if (scenario.result?.status === Status.FAILED) {
    const timestamp = Date.now();

    const screenshot = await this.page?.screenshot({
      path: `screenshot-${timestamp}.png`,
    });

    if (screenshot) {
      this.attach(screenshot, "image/png"); // ✅ sin await
    }

    const html = await this.page?.content();
    fs.writeFileSync(`page_dump-${timestamp}.html`, html || "");
  }

  await this.browser?.close();
});
