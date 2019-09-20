let students = [];
let availableGuesses = [];
let counter = 0;
let correctObject = {};
let hasGuessed = true;
let score = 0;

const qs = (el) => {
    return document.querySelector(el);
}

const qsa = (el) => {
    return document.querySelectorAll(el);
}

fetch("/json/"+id).then(res => {
    res.json().then(json => {
        students = shuffle(json);
        nextGuess();
    })
});

const generateChoices = () => {
    let arr = [];
    Object.assign(arr, students);
    temp = arr.splice(counter,1);
    arr.length = 5;
    arr.push(temp[0]);
    availableGuesses = shuffle(arr);
}

const nextGuess = () => {
    updateCounter();
    if(hasGuessed){
        if(counter < students.length){
            generateChoices();

            correctObject = students[counter];
            hasGuessed = false;
    
            appendAnswers();
            appendImage();
    
            counter++;
        } else{
            appendResults();
        } 
    } else {
        console.log("You haven't guessed yet");
    }
}

const appendImage = () => {
    qs(".quiz-image").children[0].setAttribute("src", "/uploads/" + students[counter].img)
}

const appendAnswers = () => {
    qs(".quiz-answers").innerHTML = "";
    for(guess of shuffle(availableGuesses)){
        qs(".quiz-answers").insertAdjacentHTML("beforeend", `<div id="guess_${guess.id}" class="quiz-answer" onclick="handleGuess(this, ${guess.id})"><span>${guess.first_name + " " + guess.last_name}</span></div>`)
    }
}

const handleGuess = (el, id) => {
    if(!hasGuessed){
        hasGuessed = true;
        if(id == correctObject.id) correctGuess(el);
        else incorrectGuess(el);
    } else {
        console.log("You have already made your guess!");
    }
}

const correctGuess = el => {
    score += 1;
    el.classList.add("correct");
}

const incorrectGuess = el => {
    el.classList.add("incorrect");
    obj = availableGuesses.find(el => {
        return el == correctObject
    });
    qs(`#guess_${obj.id}`).classList.add("blue");
}

const appendResults = () => {
    qs(".quiz-container").innerHTML = "";
    qs(".quiz-container").insertAdjacentHTML("beforeend", `<div class="title"><h1>Du hade ${score + " / " + students.length} rätt!</h1></div>`)
}

const updateCounter = () => {
    qs(".quiz-counter").innerHTML = "";
    qs(".quiz-counter").insertAdjacentHTML("beforeend", `<p>${counter+1 + " / " + students.length}</p>`)
}

const shuffle = (a) => {
    var j, x, i;
    for (i = a.length - 1; i > 0; i--) {
        j = Math.floor(Math.random() * (i + 1));
        x = a[i];
        a[i] = a[j];
        a[j] = x;
    }
    return a;
}