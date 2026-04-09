import { Page, Locator } from "playwright/test";

export class HeaderPage {
  readonly logoutButton: Locator;
  readonly modalLogoutConfirmButton: Locator;
  readonly username: Locator;

  constructor(page: Page) {
    this.logoutButton = page.locator('//button[@id="logout-btn"]');
    this.modalLogoutConfirmButton = page.locator(
      "//button[contains(@id, 'modal-confirm')]",
    );
    this.username = page.locator('//span[@id="user-name"]');
  }

  async clickLogoutButton() {
    await this.logoutButton.click();
  }

  async clickConfirmLogoutButton() {
    await this.modalLogoutConfirmButton.click();
  }

  async getUsername() {
    await this.username.waitFor({ state: "visible" });
    return this.username.textContent();
  }
}
