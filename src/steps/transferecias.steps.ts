import { expect } from "playwright/test";
import { CustomWorld } from "../support/world";
import { Given, Then, When } from "@cucumber/cucumber";

//BackGround: Usuario autenticado
Given(
  "el usuario ha iniciado sesion satisfactoriamente",
  async function (this: CustomWorld) {
    await this.loginPage!.goToLoginPage();
    await this.loginPage!.fillForm("demo", "demo123");
    await this.loginPage!.clickLoginButton();
  },
);

Given(
  "el usuario guarda el saldo inicial de sus cuentas",
  async function (this: CustomWorld) {
    this.saldoInicialCuentaCorriente =
      await this.profilePage!.getAccountBalance("Cuenta Corriente");
    this.saldoInicialCuentaAhorro =
      await this.profilePage!.getAccountBalance("Caja de Ahorro");
  },
);

Given(
  "el usuario hace click en el boton {string} del menu lateral",
  async function (this: CustomWorld, menuItem: string) {
    await this.sideBarPage!.clickMenuItem(menuItem);
  },
);

When(
  "el usuario selecciona tipo de transferencia {string}",
  async function (this: CustomWorld, tipo: string) {
    await this.transferenciaPage!.selectTipoTransferencia(tipo);
    this.tipoTransferencia = tipo;
  },
);

When(
  "selecciona cuenta origen {string}",
  async function (this: CustomWorld, origen: string) {
    await this.transferenciaPage!.selectCuentaOrigen(origen);
    this.cuentaOrigen = origen;
  },
);

When(
  "selecciona cuenta destino {string}",
  async function (this: CustomWorld, destino: string) {
    await this.transferenciaPage!.selectCuentaDestino(destino);
    this.cuentaDestino = destino;
  },
);

When(
  "ingresa monto {string}",
  async function (this: CustomWorld, monto: string) {
    await this.transferenciaPage!.ingresarMonto(Number.parseFloat(monto));
    this.montoIngresado = Number.parseFloat(monto);
  },
);

When("presiona TRANSFERIR", async function (this: CustomWorld) {
  await this.transferenciaPage!.clickTransferirButton();
});

When(
  "Verifica que se muestra el popup de confirmacion con los detalles correctos de la transferencia",
  async function (this: CustomWorld) {
    await this.transferenciaPage!.verifyModalContent(
      "Confirmar Transferencia",
      this.cuentaOrigen,
      this.cuentaDestino,
      this.montoIngresado,
      this.descripcion || "",
    );
  },
);

When("confirma la transferencia", async function (this: CustomWorld) {
  await this.transferenciaPage!.confirmarTransferencia();
});

Then(
  "se visualiza mensaje {string}",
  async function (this: CustomWorld, expectedMessage: string) {
    await this.transferenciaPage!.verifyTransferenciaExitosa(expectedMessage);
  },
);

Then(
  "en la pagina de dashboard se refleja el nuevo saldo de las cuentas",
  async function (this: CustomWorld) {
    await this.sideBarPage!.clickMenuItem("Inicio");
    await this.transferenciaPage!.validateTransfer(
    this.cuentaOrigen,
    this.saldoInicialCuentaAhorro!,
    this.saldoInicialCuentaCorriente!,
    this.montoIngresado
    );
  }
);
