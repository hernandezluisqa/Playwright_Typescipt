import { HeaderPage } from "./../pages/HeaderPage";
import { Given, Then, When } from "@cucumber/cucumber";
import { expect } from "@playwright/test";
import { LoginPage } from "../pages/LoginPage";
import { ProfilePage } from "../pages/ProfilePage";
import { CustomWorld } from "../support/world";

Given(
  "el usuario se encuenta en la pagina de Login de Home Banking",
  async function (this: CustomWorld) {
    const loginPage = new LoginPage(this.page!);
    await loginPage.goToLoginPage();
  },
);

When(
  "ingresa el usuario {string} y la contraseña {string}",
  async function (this: CustomWorld, username: string, password: string) {
    const loginPage = new LoginPage(this.page!);
    await loginPage.fillForm(username, password);
  },
);

When("hace clic en el botón Ingresar", async function (this: CustomWorld) {
  const loginPage = new LoginPage(this.page!);
  await loginPage.clickLoginButton();
});

Then(
  "debería ser redirigido al panel principal del usuario {string}",
  async function (this: CustomWorld, userNameExpected: string) {
    const profilePage = new ProfilePage(this.page!);
    const headerPage = new HeaderPage(this.page!);
    const actualUSername = await headerPage.getUsername();
    const actualTitle = await profilePage.verifyOnProfilePage();
    expect(actualUSername).toBe(userNameExpected);
    expect(actualTitle).toBe("Panel Principal");
  },
);

Then("se muestra mensaje de error", async function (this: CustomWorld) {
  const loginPage = new LoginPage(this.page!);
  const expectedMessageError = "Usuario o contraseña incorrectos";
  await expect(loginPage.errorMessage).toBeVisible();
  await expect(loginPage.errorMessage).toContainText(expectedMessageError);
});

Then("permanece en Login", async function (this: CustomWorld) {
  const loginPage = new LoginPage(this.page!);
  await expect(loginPage.loginButton).toBeVisible();
});
