import { Component, OnInit } from '@angular/core';

@Component({
	selector: 'app-root',
	templateUrl: './app.component.html',
	styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
	title = 'td4app';
	index: number;
	score: number;
	show: boolean;
	ngOnInit(){ this.reset() }
	reset(){
		this.index = 1;
		this.score = 0;
		this.show = true;
	}
	chgScore(score:number) {
		if (score >= 0) {
			this.score += score;
		}
		else {
			this.show = false;
		}
	}

	guess() {
		this.index += 1
	}
}
