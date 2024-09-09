import { Component, Input } from '@angular/core';
import { ModalController } from '@ionic/angular/standalone';
import { CommonModule } from '@angular/common';
import { IonHeader,IonInput,IonItem, IonButtons,IonToolbar,IonLabel,IonTitle, IonContent, IonButton } from '@ionic/angular/standalone';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-point-modal',
  templateUrl: './point-modal.component.html',
  styleUrls: ['./point-modal.component.scss'],
  imports:[IonHeader,CommonModule,IonItem,IonButtons,FormsModule,IonLabel,IonInput, IonToolbar, IonTitle, IonContent, IonButton],
  standalone: true,
})
export class PointModalComponent {
  @Input() point: { id: number; name: string; description: string } = { id: 0, name: '', description: '' };

  constructor(private modalController: ModalController) {}

  dismiss() {
    this.modalController.dismiss();
  }

  save() {
    // Envia os dados do ponto atualizados
    this.modalController.dismiss(this.point);
  }
}
