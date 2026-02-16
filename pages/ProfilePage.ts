import { Page, Locator, expect } from "@playwright/test";

export class ProfilePage {
    readonly page: Page;
    readonly title: Locator;
    readonly username: Locator;
    readonly logoutButton: Locator;
    readonly modalLogoutConfirmButton: Locator;     

    constructor(page: Page) {
        this.page = page;
        this.title = page.locator('//h2[text()="Panel Principal"]');
        this.username = page.locator('//span[@id="user-name"]');
        this.logoutButton = page.locator('//button[@id="logout-btn"]');
        this.modalLogoutConfirmButton = page.locator("//button[contains(@id, 'modal-confirm')]");
    }

    async getTitle() {
        await this.title.waitFor({state: 'visible'})
        return this.title.textContent();
    }

    async getUsername() {
        await this.username.waitFor({state: 'visible'})
        return this.username.textContent();
    }

    async clickLogoutButton(){
        await this.logoutButton.click()
    }

    async clickConfirmLogoutButton(){
        await this.modalLogoutConfirmButton.click()
    }

}
