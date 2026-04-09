import { Page, Locator } from "@playwright/test";

export class ProfilePage {
  readonly page: Page;
  readonly title: Locator;

  constructor(page: Page) {
    this.page = page;
    this.title = page.locator('//h2[text()="Panel Principal"]');
  }

  async getTitle() {
    await this.title.waitFor({ state: "visible" });
    return this.title.textContent();
  }
}
