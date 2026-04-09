import { expect, Locator, Page } from "playwright/test";

export class SideBarPage {
  readonly inicioButton: Locator;
  readonly transferenciasButton: Locator;
  readonly plazosFijosButton: Locator;
  readonly prestamosButton: Locator;
  readonly pagoServiciosButton: Locator;
  readonly tarjetaVirtualButton: Locator;
  readonly misDatosButton: Locator;

  constructor(page: Page) {
    this.inicioButton = page.locator("//li[@data-view='dashboard']");
    this.transferenciasButton = page.locator("//li[@data-view='transfer']");
    this.plazosFijosButton = page.locator("//li[@data-view='fixed-deposit']");
    this.prestamosButton = page.locator("//li[@data-view='loans']");
    this.pagoServiciosButton = page.locator("//li[@data-view='services']");
    this.tarjetaVirtualButton = page.locator("//li[@data-view='cards']");
    this.misDatosButton = page.locator("//li[@data-view='client-data']");
  }

  async clickInicioButton() {
    expect(this.inicioButton).toBeVisible();
    expect(this.inicioButton).toBeEnabled();
    await this.inicioButton.click();
  }

  async clickTransferenciasButton() {
    expect(this.transferenciasButton).toBeVisible();
    expect(this.transferenciasButton).toBeEnabled();
    await this.transferenciasButton.click();
  }

  async clickPlazosFijosButton() {
    expect(this.plazosFijosButton).toBeVisible();
    expect(this.plazosFijosButton).toBeEnabled();
    await this.plazosFijosButton.click();
  }

  async clickPrestamosButton() {
    expect(this.prestamosButton).toBeVisible();
    expect(this.prestamosButton).toBeEnabled();
    await this.prestamosButton.click();
  }

  async clickPagoServiciosButton() {
    expect(this.pagoServiciosButton).toBeVisible();
    expect(this.pagoServiciosButton).toBeEnabled();
    await this.pagoServiciosButton.click();
  }

  async clickTarjetaVirtualButton() {
    expect(this.tarjetaVirtualButton).toBeVisible();
    expect(this.tarjetaVirtualButton).toBeEnabled();
    await this.tarjetaVirtualButton.click();
  }

  async clickMisDatosButton() {
    expect(this.misDatosButton).toBeVisible();
    expect(this.misDatosButton).toBeEnabled();
    await this.misDatosButton.click();
  }
}
