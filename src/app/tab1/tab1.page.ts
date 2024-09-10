import { Component, OnInit } from '@angular/core';
import { IonHeader,IonImg,IonGrid, IonToolbar, IonTitle,IonRow ,IonCol,IonContent, ModalController } from '@ionic/angular/standalone';
import interact from 'interactjs';
import { PointModalComponent } from '../point-modal/point-modal.component';
import { TableModule } from 'primeng/table';
import { NgbTooltipModule } from '@ng-bootstrap/ng-bootstrap';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-tab1',
  templateUrl: './tab1.page.html',
  styleUrls: ['./tab1.page.scss'],
  standalone: true,
  imports: [IonHeader,IonGrid,CommonModule,IonRow,IonImg,IonCol, IonToolbar, NgbTooltipModule, IonTitle, IonContent, TableModule],
})


export class Tab1Page implements OnInit {
  points: { id: number; name: string; description: string; x: number; y: number }[] = [];
  pointIdCounter = 0;
  imageSrc: string | ArrayBuffer | null = null;

  constructor(private modalController: ModalController) {}

  ngOnInit() {
    this.setupClickListener();
    this.initializeInteractJs();
  }

  private setupClickListener() {
    const container = document.getElementById('points-container');

    if (container) {
      container.addEventListener('click', (event) => {
        const rect = container.getBoundingClientRect();
        const x = event.clientX - rect.left;
        const y = event.clientY - rect.top;

        this.createPoint(x, y);
      });
    }
  }

  private createPoint(x: number, y: number) {
    const container = document.getElementById('points-container');
    
    if (!container) return;
    
    const point = document.createElement('div');
    point.className = 'draggable-point';
    point.style.position = 'absolute';
    point.style.width = '50px';
    point.style.height = '50px';
    point.style.backgroundColor = 'red';
    point.style.color = 'white';
    point.style.textAlign = 'center';
    point.style.lineHeight = '50px';
    point.style.borderRadius = '50%';
    point.style.left = `${x - 25}px`; 
    point.style.top = `${y - 25}px`; 
    point.innerText = 'Point';
    

    point.setAttribute('data-name', `Nome: ${this.pointIdCounter}`);
    point.setAttribute('data-description', 'Descrição: Descrição do ponto');


    point.addEventListener('click', async (event) => {
      event.stopPropagation();
      const id = this.pointIdCounter; 
      await this.openModal({ id, name: point.getAttribute('data-name') || '', description: point.getAttribute('data-description') || '', x, y });
    });
    
    container.appendChild(point);
    
    this.initializeInteractJsForPoint(point);
    
    this.pointIdCounter++;
  }

  private async openModal(point: { id: number; name: string; description: string; x: number; y: number }) {
    const modal = await this.modalController.create({
      component: PointModalComponent,
      componentProps: { point }
    });
  
    modal.onDidDismiss().then((result) => {
      if (result.data) {
        // Atualiza o ponto com os dados do modal
        const updatedPoint = result.data;
        console.log('Dados do ponto atualizados:', updatedPoint);
        // Atualiza a URL da imagem se necessário
        this.updatePointInContainer(updatedPoint);
      }
    });
  
    return await modal.present();
  }

  private updatePointInContainer(updatedPoint: { id: number; name: string; description: string; x: number; y: number }) {
    const container = document.getElementById('points-container');
    if (!container) return;
    
    const pointElement = Array.from(container.getElementsByClassName('draggable-point'))
      .find(el => (el as HTMLElement).innerText === 'Point') as HTMLElement; // Cast para HTMLElement
  
    if (pointElement) {
      pointElement.setAttribute('data-name', `Nome: ${updatedPoint.name}`);
      pointElement.setAttribute('data-description', `Descrição: ${updatedPoint.description}`);
      pointElement.style.left = `${updatedPoint.x - 25}px`; 
      pointElement.style.top = `${updatedPoint.y - 25}px`; 
    }
  }
  

  private initializeInteractJs() {
    interact('.draggable-point').draggable({
      listeners: {
        move(event) {
          const target = event.target as HTMLElement;
          const x = (parseFloat(target.getAttribute('data-x') || '0') + event.dx);
          const y = (parseFloat(target.getAttribute('data-y') || '0') + event.dy);

          target.style.transform = `translate(${x}px, ${y}px)`;

          target.setAttribute('data-x', x.toString());
          target.setAttribute('data-y', y.toString());
        },
        end(event) {
          console.log('Point dragged to:', event.target);
        }
      }
    });
  }

  private initializeInteractJsForPoint(point: HTMLElement) {
    interact(point).draggable({
      listeners: {
        move(event) {
          const x = (parseFloat(point.getAttribute('data-x') || '0') + event.dx);
          const y = (parseFloat(point.getAttribute('data-y') || '0') + event.dy);

          point.style.transform = `translate(${x}px, ${y}px)`;

          point.setAttribute('data-x', x.toString());
          point.setAttribute('data-y', y.toString());
        },
        end(event) {
          console.log('Point dragged to:', event.target);
        }
      }
    });
  }

  // Manipula o evento de upload de imagem
  onImageUpload(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      const file = input.files[0];
      const reader = new FileReader();
      
      reader.onload = () => {
        this.imageSrc = reader.result;
      };
      
      reader.readAsDataURL(file);
    }
  }
}
