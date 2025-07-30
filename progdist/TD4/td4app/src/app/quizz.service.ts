import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Quizz } from './quizz'

@Injectable({
	providedIn: 'root'
})
export class QuizzService {

	constructor(private http:HttpClient) {}
	getQuizz(index:number):Observable<Quizz> {
		return this.http.get<Quizz>('api/quizz/$index');
	}
}
