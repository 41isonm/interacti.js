import { Component } from '@angular/core';
import { IonHeader,IonSelectOption,IonSelect,IonItem,IonList, IonToolbar, IonTitle, IonContent,IonInput,IonButton,IonRow,IonCol,IonLabel } from '@ionic/angular/standalone';

@Component({
  selector: 'app-tab2',
  templateUrl: 'tab2.page.html',
  styleUrls: ['tab2.page.scss'],
  standalone: true,
  imports: [IonHeader, IonToolbar,IonSelectOption,IonSelect,IonItem,IonList, IonTitle, IonContent,IonInput,IonButton,IonRow,IonCol,IonLabel]
})
export class Tab2Page {

  constructor() {}

}
