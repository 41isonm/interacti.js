import { Annotorious } from '@recogito/annotorious';

import '@recogito/annotorious/dist/annotorious.min.css';import { Component, OnInit } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, ModalController } from '@ionic/angular/standalone';
import interact from 'interactjs';
import { PointModalComponent } from '../point-modal/point-modal.component';
import { TableModule } from 'primeng/table';
@Component({
  selector: 'app-tab1',
  templateUrl: './tab1.page.html',
  styleUrls: ['./tab1.page.scss'],
  standalone: true,
  imports: [IonHeader, IonToolbar, IonTitle, IonContent, TableModule],
})
export class Tab1Page implements OnInit {

  private anno: any; 

  constructor(private modalController: ModalController) {}

  ngOnInit() {
    this.setupClickListener();
    this.initializeInteractJs();
    this.initializeAnnotorious(); // Inicializa o Annotorious
  }

  // Inicializa o Annotorious para anotações em uma imagem específica
  private initializeAnnotorious() {
    const imageElement = document.getElementById('annotatable-image') as HTMLImageElement;
    if (imageElement) {
      this.anno = Annotorious.init(
        {
          image:imageElement
        }
      );
 

      // Exemplo: Adicionar listener para capturar a criação de anotações
      this.anno.on('createAnnotation', (annotation: any) => {
        console.log('Anotação criada:', annotation);
      });
    }
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
    point.style.left = `${x - 25}px`; // Centraliza o ponto
    point.style.top = `${y - 25}px`; // Centraliza o ponto
    point.innerText = 'Point';

    // Adiciona evento de click no ponto
    point.addEventListener('click', async (event) => {
      event.stopPropagation(); // Previne o evento de clique no container
      await this.openModal(); // Abre o modal
    });

    container.appendChild(point);

    this.initializeInteractJsForPoint(point);
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
          console.log('Ponto movido para:', event.target);
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
          console.log('Ponto movido para:', event.target);
        }
      }
    });
  }

  private async openModal() {
    const modal = await this.modalController.create({
      component: PointModalComponent
    });
    return await modal.present();
  }
}
