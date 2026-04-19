import { Page, Locator } from "@playwright/test";

export class ProfilePage {
  readonly page: Page;
  readonly title: Locator;

  constructor(page: Page) {
    this.page = page;
    this.title = page.locator('//h2[text()="Panel Principal"]');
  }

  async verifyOnProfilePage() {
    await this.title.waitFor({ state: "visible" });
    return this.title.textContent();
  }

  async getAccountBalance(accountName: string): Promise<number> {
    const accountContainer = this.page.locator(
      `.account-card:has-text("${accountName}")`,
    );

    const balanceLocator = accountContainer.locator(".balance-value");

    let previous = -1;
    let balance = 0;
    let i = 0;

    while (balance !== previous && i < 10) {
      previous = balance;

      const balanceText = await balanceLocator.textContent();

      if (!balanceText) {
        throw new Error(`No se encontró saldo para ${accountName}`);
      }

      const balanceCleaned = balanceText
        .replaceAll("$", "")
        .replaceAll(".", "")
        .replace(",", ".")
        .trim();

      balance = Number.parseFloat(balanceCleaned);

      i++;

      await this.page.waitForTimeout(200);
    }

    return balance;
  }
}
