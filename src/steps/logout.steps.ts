import { Given, When, Then } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import { CustomWorld } from "../support/world";
import { ProfilePage } from "../pages/ProfilePage";
import { LoginPage } from "../pages/LoginPage";
import { HeaderPage } from "../pages/HeaderPage";

Given(
  "el usuario ha iniciado sesion exitosamente",
  async function (this: CustomWorld) {
    const loginPage = new LoginPage(this.page!);
    await loginPage.goToLoginPage();
    await loginPage.fillForm("demo", "demo123");
    await loginPage.clickLoginButton();
  },
);

Given(
  "el usuario se encuentra en la pagina de Dashboard",
  async function (this: CustomWorld) {
    const profilePage = new ProfilePage(this.page!);
    await expect(profilePage.title).toBeVisible();
  },
);

When(
  "el usuario hace click en boton salir",
  async function (this: CustomWorld) {
    const headerPage = new HeaderPage(this.page!);
    await headerPage.clickLogoutButton();
  },
);

When(
  "da click en el boton confirmar del modal de confirmacion",
  async function (this: CustomWorld) {
    const headerPage = new HeaderPage(this.page!);
    await headerPage.clickConfirmLogoutButton();
  },
);

Then(
  "el usuario es redirigido a la pagina de login",
  async function (this: CustomWorld) {
    const loginPage = new LoginPage(this.page!);
    await expect(loginPage.loginButton).toBeVisible();
  },
);
