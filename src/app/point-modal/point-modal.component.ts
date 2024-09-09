import { Component, Input } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { IonHeader,IonButtons,ModalController, IonToolbar, IonTitle, IonContent, IonButton, IonInput, IonItem, IonLabel } from '@ionic/angular/standalone';

@Component({
  selector: 'app-point-modal',
  templateUrl: './point-modal.component.html',
  styleUrls: ['./point-modal.component.scss'],
  standalone: true,
  imports: [IonHeader, IonToolbar,IonButtons, IonTitle, IonContent,IonButton,IonInput,IonItem,IonLabel],

})
export class PointModalComponent {
  @Input() point?: { id: number; name: string };

  constructor(private modalController: ModalController) {}

  dismiss() {
    this.modalController.dismiss();
  }

  save() {
    // Aqui você pode salvar a alteração (ex: enviar para um backend)
    console.log('Dados do ponto atualizados:', this.point);
    this.dismiss();
  }

  removePoint(id: number, event: MouseEvent | TouchEvent) {

  }
}
