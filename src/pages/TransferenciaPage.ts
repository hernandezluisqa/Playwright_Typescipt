import { expect, Locator, Page } from "playwright/test";
import { ProfilePage } from "./ProfilePage";

export class TransferenciaPage {
  readonly page: Page;
  readonly title: Locator;
  readonly tipoTransferenciaSelect: Locator;
  readonly cuentaOrigenSelect: Locator;
  readonly cuentaDestinoSelect: Locator;
  readonly montoInput: Locator;
  readonly descripcionInput: Locator;
  readonly transferirButton: Locator;
  readonly modalTitulo: Locator;
  readonly modalCuentaOrigen: Locator;
  readonly modalCuentaDestino: Locator;
  readonly modalMonto: Locator;
  readonly modalDescripcion: Locator;
  readonly modalConfirmarButton: Locator;
  readonly modalCancelarButton: Locator;
  readonly cerrarModalButton: Locator;
  readonly mensajeTransferenciaExito: Locator;

  constructor(page: Page) {
    this.page = page;
    this.title = page.getByRole("heading", { name: "Transferencias" });
    this.tipoTransferenciaSelect = page.locator("#transfer-type");
    this.cuentaOrigenSelect = page.locator("#source-account");
    this.cuentaDestinoSelect = page.locator("#destination-own-account");
    this.montoInput = page.locator("#transfer-amount");
    this.descripcionInput = page.locator("#transfer-description");
    this.transferirButton = page.getByRole("button", { name: "Transferir" });
    this.modalTitulo = page.locator("#modal-title");
    this.modalCuentaOrigen = page.locator(
      '//span[contains(text(),"Cuenta origen")]/../span[@class="summary-value"]',
    );
    this.modalCuentaDestino = page.locator(
      '//span[contains(text(),"Cuenta destino")]/../span[@class="summary-value"]',
    );
    this.modalMonto = page.locator(
      '//span[contains(text(),"Monto")]/../span[contains(@class,"summary-value")]',
    );
    this.modalDescripcion = page.locator("");
    this.modalConfirmarButton = page.getByRole("button", { name: "Confirmar" });
    this.modalCancelarButton = page.getByRole("button", { name: "Cancelar" });
    this.cerrarModalButton = page.locator("#modal-close");
    this.mensajeTransferenciaExito = page.locator(".toast-message");
  }

  async verifyOnTransferenciaPage() {
    await expect(this.title).toBeVisible();
  }

  async selectTipoTransferencia(tipo: string) {
    await this.tipoTransferenciaSelect.selectOption({ label: tipo.trim() });
  }

  async selectCuentaOrigen(cuenta: string) {
    const option = this.cuentaOrigenSelect
      .locator("option")
      .filter({ hasText: cuenta })
      .first();
    const value = await option.getAttribute("value");
    await this.cuentaOrigenSelect.selectOption(value);
  }

  async selectCuentaDestino(cuenta: string) {
    const option = this.cuentaDestinoSelect
      .locator("option", { hasText: cuenta })
      .first();
    const value = await option.getAttribute("value");
    await this.cuentaDestinoSelect.selectOption(value);
  }

  async ingresarMonto(monto: number) {
    await this.montoInput.fill(monto.toString());
  }

  async ingresarDescripcion(descripcion: string) {
    await this.descripcionInput.fill(descripcion);
  }

  async clickTransferirButton() {
    await this.transferirButton.click();
  }

  async verifyModalContent(
    titulo: string,
    cuentaOrigen: string,
    cuentaDestino: string,
    monto: number,
    descripcion: string,
  ) {
    await expect(this.modalTitulo).toBeVisible();
    await expect(this.modalTitulo).toHaveText(titulo);
    await expect(this.modalCuentaOrigen).toContainText(cuentaOrigen);
    await expect(this.modalCuentaDestino).toContainText(cuentaDestino);
    const rawText = await this.modalMonto.textContent();

    const numericValue = Number(
      rawText!.replace(/\$/g, "").replace(/\./g, "").replace(",", ".").trim(),
    );

    expect(numericValue).toBe(monto);
    if (descripcion) {
      await expect(this.modalDescripcion).toContainText(descripcion);
    }
  }

  async confirmarTransferencia() {
    await this.modalConfirmarButton.click();
  }

  async cancelarTransferencia() {
    await this.modalCancelarButton.click();
  }

  async cerrarModal() {
    await this.cerrarModalButton.click();
  }

  async verifyTransferenciaExitosa(message: string) {
    let messageLocator = this.mensajeTransferenciaExito.getByText(message);
    await expect(messageLocator).toBeVisible();
    await expect(messageLocator).toHaveText(message);
  }

  async validateTransfer(
    cuentaOrigen: string,
    saldoInicialCuentaAhorro: number,
    saldoInicialCuentaCorriente: number,
    montoIngresado: number
  ) {
    const profilePage = new ProfilePage(this.page);

    const nuevoSaldoCuentaCorriente =
      await profilePage.getAccountBalance("Cuenta Corriente");

    const nuevoSaldoCuentaAhorro =
      await profilePage.getAccountBalance("Caja de Ahorro");

    const origen = cuentaOrigen.toLowerCase();

    if (origen.includes("corriente")) {
      expect(nuevoSaldoCuentaCorriente).toBe(
        saldoInicialCuentaCorriente - montoIngresado
      );
      expect(nuevoSaldoCuentaAhorro).toBe(
        saldoInicialCuentaAhorro + montoIngresado
      );
    } else if (origen.includes("ahorro")) {
      expect(nuevoSaldoCuentaCorriente).toBe(
        saldoInicialCuentaCorriente + montoIngresado
      );
      expect(nuevoSaldoCuentaAhorro).toBe(
        saldoInicialCuentaAhorro - montoIngresado
      );
    } else {
      throw new Error(`Cuenta origen no válida: ${cuentaOrigen}`);
    }
  }

}
