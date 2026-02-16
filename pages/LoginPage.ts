import { Locator, Page } from '@playwright/test';

export class LoginPage {
  readonly page: Page;
  readonly usernameInput: Locator;
  readonly passwordInput: Locator;
  readonly loginButton: Locator;
  readonly errorMessage: Locator;

  constructor(page: Page) {
    this.page = page;
    this.usernameInput = page.locator('//input[@id="username"]');
    this.passwordInput = page.locator('//input[@id="password"]');
    this.loginButton = page.locator('//button[@id="login-btn"]');
    this.errorMessage = page.locator('//div[@id="login-error"]');
  }

  async goToLoginPage() {
    await this.page.goto('https://homebanking-demo-tests.netlify.app/');
  }

  async fillForm(UserName: string, Password: string) {
    await this.usernameInput.fill(UserName);
    await this.passwordInput.fill(Password);
  }

  async clickLoginButton(){
    await this.loginButton.click()
  }

  async getErrorMessage() {
    await this.errorMessage.waitFor({state: 'visible'})
    return this.errorMessage.textContent();
  }
}
