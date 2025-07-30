import { Component, EventEmitter, Input, Output } from '@angular/core';
import { QuizzService } from '../quizz.service'
import { Quizz } from '../quizz'

@Component({
	selector: 'app-quizz',
	templateUrl: './quizz.component.html',
	styleUrls: ['./quizz.component.css']
})
export class QuizzComponent {
	show:boolean;
	_index:number;
	quizz:Quizz;
	answer:string|null;

	@Output() scoreChange = new EventEmitter<number>();

	constructor(private quizzService:QuizzService) {}

	@Input()
	set index (value:number) {
		if (this.answer) {
			let response = 0;
			if (`${this.quizz.answer}` === this.answer) {
				response = 1;
			}
			this.scoreChange.emit(response);
		}
		this.answer = null;
		this._index = value;
		this.getQuizz();
	}

	get index() {
		return this._index;
	}

	private getQuizz() {
		this.quizzService.getQuizz(this._index).subscribe(quizz => {
			this.quizz = quizz;
			this.show = true;
		}, error => {
			this.scoreChange.emit(-1);
			this.show = false;
		});
	}
}
