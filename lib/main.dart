import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';

// Q 45 and Q 48-1 images -> Group1 9
// Q12-1 and Q57 Images -> Group2 5
// Q18-1 Images -> Group3 9
// Q27-1 and Q33-1  Images -> Group4 8



void main() {
  runApp (
    MaterialApp(
     title: "CO19-SMS",
     home: initialApp() 
  ));
}


// questions types 
// 1 ---> Yes or no question
// 2 ---> Slider question
// 3 ---> images
// 4 ---> multipleChoices questions




class majorSymptoms{
  
  final String title;
  final List<Question> questions;
  bool? answerd = false;
  majorSymptoms({required this.title ,required this.questions});
} 
class Question {

  bool? view = true;
  Question({required this.questionName , required this.id , required this.questionType, required this.score,
                  this.subQuesiton , this.parentId , 
                  this.sliderRange , this.sliderDivisions , this.scores , this.rightAnswer, this.view , this.imageURL , this.numberOfImages , this.multipleChoices});

  bool? answered = false;
  String? answer; // for the yes no question 
  double? sliderAnswer = -1;

  final String questionName;
  final int id;
  final int questionType;

  final String? rightAnswer;
  final List<int>? scores;


  final bool? subQuesiton;
  final int? parentId;
  final int score;
  final int? sliderDivisions;
  final List<int>?  sliderRange;


  // here are the attributes for the images questions
  final String? imageURL;
  List<int> imagesPicked = [0];
  final int? numberOfImages;


  // here are the attributes used for the multiple choice questions

  final List<String>? multipleChoices;

}

// here the image devleoped



// here the image devleoped

class Try extends StatefulWidget{
  final List<majorSymptoms> symptoms;

  const Try({Key? key  , required this.symptoms}) : super(key: key);

  @override
  State<Try> createState() => _Try();
}
class _Try extends State<Try>{
  

  @override
  Widget build(BuildContext context){
    

      List<majorSymptoms> symptoms = widget.symptoms;

      Future<void> _navigateAndDisplaySelection(BuildContext context , int index) async {
        // Navigator.push returns a Future that completes after calling
        // Navigator.pop on the Selection Screen.
          final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  QuestionsApp(Questions: symptoms[index].questions , title : symptoms[index].title)
              ));
          for (int i = 0; i < symptoms.length;i++){
            if(symptoms[i].title == result){
              this.setState(() {
                 symptoms[i].answerd = true;
              });
             
              break;
            }
          }

      }


    return Scaffold(
      appBar: AppBar(title: Text("Symptoms List"),
              // actions: [
              //    ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //           primary: Color.fromARGB(180, 8, 234, 54),
              //           // minimumSize: Size(88, 36),
              //           // padding: EdgeInsets.symmetric(horizontal: 30.0),
                  
              //           // shape: StadiumBorder(),
                       
              //       ),
              //       onPressed: () { 
              //         Navigator.push(context,
              //          MaterialPageRoute( 
              //           builder: (context) => Text("here")
              //           ));
              //       },
              //       child: Text(
              //         "Finish",
              //         )
              //     ),
              // ],
      ),
      body:
      Container(
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("assets/images/Logo/background.jpg"),
            //     fit: BoxFit.cover,
            //     ),
            //   ),
              child:       ListView.separated( 
        itemCount: symptoms.length, 
        // physics: BouncingScrollPhysics(),
        // shrinkWrap: true,
         separatorBuilder: (context, index) {
          return SizedBox(
              height: 0.5,
                child: Divider(
                height: 1,
                thickness: 1,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            );
          
          
        },
        itemBuilder: (context , index){
          Color tileColor = (symptoms[index].answerd == true)? Color.fromARGB(166, 28, 196, 34) : Color.fromARGB(0, 244, 67, 54) ;
          return ListTile(
                enabled:true,
                tileColor: tileColor,
                title: Text(
                  symptoms[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600 , 
                    fontSize: 19,
                    fontFamily: 'Roboto'
                  ),
                  
                  ),
                onTap: (){
                  _navigateAndDisplaySelection(context , index);
                },
              );


      },),
      ) ,

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final preHistory_questions = ModalRoute.of(context)!.settings.arguments as List<Question>;
          int preHistory_total_score = 0;
          int total_symtoms_score  = 0;

          List<int> Symtoms_total_scores = [];
          preHistory_questions.forEach((element) {

            if(element.questionType == 1){
              if(element.answer == element.rightAnswer){
                preHistory_total_score += element.score;
              }
            }else if(element.questionType == 4){
              if(element.answered == true){
                int index = 0;
                for (int i =0;i<element.multipleChoices!.length;i++){
                  if(element.answer == element.multipleChoices![i]){
                    index = i;
                    break;
                  }
                }
                preHistory_total_score += element.scores![index];
              }
              
            }
          
          });
          int counter = 0;
          widget.symptoms.forEach((element) {
            Symtoms_total_scores.add(counter);
            element.questions.forEach((element) {
              if(element.questionType == 1){
                if(element.answer == element.rightAnswer){
                  preHistory_total_score += element.score;
                  Symtoms_total_scores[counter]+=element.score;
                  total_symtoms_score+=element.score;
                }
              
              }else if(element.questionType == 2){
                if(element.sliderAnswer! >= 37 &&  element.sliderAnswer! < 38){
                  Symtoms_total_scores[counter]+=2;
                  total_symtoms_score+=2;
                }else if(element.sliderAnswer! >= 38 &&  element.sliderAnswer! < 40){
                  Symtoms_total_scores[counter]+=4;
                  total_symtoms_score+=4;
                }else if(element.sliderAnswer! >= 40 &&  element.sliderAnswer! < 42){
                  Symtoms_total_scores[counter]+=10;
                  total_symtoms_score+=10;
                }else if(element.sliderAnswer! == 42){
                  Symtoms_total_scores[counter]+=20;
                  total_symtoms_score+=20;
                }

              }else if(element.questionType == 3){
                if(element.imagesPicked.length > 0){
                   Symtoms_total_scores[counter]+=element.score;
                   total_symtoms_score+=element.score;
                }

              }else if(element.questionType == 4){
                if(element.answered == true){
                  int index = 0;
                  for (int i =0;i<element.multipleChoices!.length;i++){
                    if(element.answer == element.multipleChoices![i]){
                      index = i;
                      break;
                    }
                  }
                  Symtoms_total_scores[counter]+=element.scores![index];
                  total_symtoms_score+=element.scores![index];
                }
              }

            });
            counter++;
          });
          int total_score = total_symtoms_score + preHistory_total_score;
          Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FinalAssessmentEvaluation(score : total_score)
            ));
        },
        child: const Icon(
          Icons.done_all,
          color: Color.fromARGB(255, 250, 250, 250),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );

  }
  
}

typedef changeYesNoState = Function(bool value);
typedef answerQuestionYesNo = Function(int id , bool value);
typedef answerQuestionSlider = Function (int id , double value);
typedef addImageAnswer = Function (int id);
typedef setChoiceFunction = Function (String answer);
typedef clearChoiceFunction = Function ();

class QuestionsApp extends StatefulWidget {
  // This widget is the root of your application.
  const QuestionsApp({required this.Questions , required this.title, Key? key }) : super(key: key);
  final String title;
  final List<Question> Questions;
  
  @override
  State<QuestionsApp> createState() => _QuestionsApp();

}
class _QuestionsApp extends State<QuestionsApp>{

@override
Widget build(BuildContext context) {

    List<Question> questionsList = widget.Questions;

    void _changeanswerQuestionYesNo(int id , bool value) {
          setState(() {
            questionsList[id].answered = value;

          });
        }

    void _changeanswerQuestionSlider(int id , double value){
      setState(() {
        questionsList[id].sliderAnswer = value;
        questionsList[id].answered = true;
      });
    }
  
    for(int i = 0; i<questionsList.length; i++){
        
        for(int j = 0; j<questionsList.length;j++){
          if(questionsList[i].id == questionsList[j].parentId){
            questionsList[j].view = questionsList[i].answered;
          }
          
        }
        // set the answer of the question of the type 1 (yes or no question)
        if(questionsList[i].questionType == 1){
          if(questionsList[i].answered == true){
            questionsList[i].answer = "yes";
          }else{
            questionsList[i].answer = "no";
          }
        }
        else if(questionsList[i].questionType == 2){
          // print(questionsList[i].answer);
        }
    }

    final questionSet = <Widget>{};

    for (int i = 0; i<questionsList.length; i++){
      if(questionsList[i].view == false) continue;
      if(questionsList[i].questionType == 1){
        questionSet.add(QuestionYN(QuestionName: questionsList[i].questionName , 
                                    id : i , 
                                    answerQuestionYesNoFunction: (int id , bool value) => _changeanswerQuestionYesNo(i , value),
                                    defaultAnswer : questionsList[i].answered
                                    ));
      }
      else if(questionsList[i].questionType == 2){
        questionSet.add(QuestionSlider(QuestionName: questionsList[i].questionName,
                                        id : i ,
                                        answerQuestionSliderFunction: _changeanswerQuestionSlider,
                                        sliderRange: questionsList[i].sliderRange,
                                        sliderDivisions: questionsList[i].sliderDivisions,
                                        defaultAnswer : questionsList[i].sliderAnswer
                                        ));
      
      }
      else if(questionsList[i].questionType == 3 ){
         questionSet.add(ImageQuestion(ImageQuesiton: questionsList[i]));    
      }else if( questionsList[i].questionType == 4){
        questionSet.add(MultipleQuestions(choiceQuestion: questionsList[i]));    
      }

     
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
      body: Container(
         decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Logo/background.jpg"),
                fit: BoxFit.cover,
                ),
              ),
            child:       ListView(children: questionSet.toList().map((e) {
              return Column(
                children: [
                    SizedBox(height: 25,),
                    e,                   
                ],
              );
            }).toList(),
          ),
        ),
      

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context , widget.title);
        },
        child: const Icon(
          Icons.check,
          color: Color.fromARGB(255, 250, 250, 250),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
       );
  }
}

class initialApp extends StatelessWidget{


    const initialApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context){
      return (
        Scaffold(
            appBar: AppBar(title: Text("CO19-SMS"),
            ),

            body: Container(
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Logo/background.jpg"),
                fit: BoxFit.cover,
                ),
              ),
              child: Column(
                  children: [
                    Expanded(child: 
                                Container(
                                  child: Image.asset("assets/images/Logo/logo_1.png") ,
                                )
                    ),
                   
                   Container(
                    padding: EdgeInsets.only( bottom: 20,right: 100 ),
                    child:ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(180, 6, 105, 225),
                          minimumSize: Size(200, 40),
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                    
                          shape: StadiumBorder(),
                          side: BorderSide(
                            width: 1,
                            color: Color.fromARGB(230, 6, 119, 225),
                          ),
                      ),
                      onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreHistory(Questions: [

                          Question(questionName: "What is your gender ?",scores: [1,1], id: 1, questionType:4 , score: 1 , multipleChoices: ["Male","Female"]),
                          Question(questionName: "What is your gender ?", id: 2, scores: [2,2,5],questionType:4 , score: 1 , multipleChoices: ["18-24","25-29","30-35"]),
                          Question(questionName: "Have you ever been diagnosed with COVID-19 before ?", rightAnswer: "yes", id: 3, questionType:1, score: 2),
                          Question(questionName: "Do you live with or care for someone who has COVID-19 ?", id:4, questionType:1, rightAnswer: "yes",score: 2),
                          Question(questionName: "Have you traveled outside of your country in the past 14 days ?", id: 5, questionType:1, rightAnswer: "yes",score: 2),
                          Question(questionName: "Do you have any of hurt, kidney, or lung chronic disease ?", id: 6, questionType:1,rightAnswer: "yes",score: 10),
                          Question(questionName: "Do you have any other condtition that might increase your risk of infiction such as cancer or diabetes ?", id: 7, questionType:1, rightAnswer: "yes",score: 10),
                          Question(questionName: "Do you or any member of your household/family have a confirmed diagnosis of COVID-19 ?", id: 8, questionType:1, rightAnswer: "yes",score: 5),
                          Question(questionName: "Have you had contact with someone with a confirmed diagnosis of COVID-19, or been in isolation with a suspected case in the last 14 days ?", id: 9, questionType:1,rightAnswer: "yes",score: 5),
                          Question(questionName: "Have you been vaccinated ?", id: 10, questionType:1, rightAnswer: "no",score: 4),
                          Question(questionName: "Do you have any of the following symptoms ( high temprature or fever) ( new, contiuous cough ) ( Loss or alteration to taste or smell ) ?", id:11, questionType:1, rightAnswer: "yes",score: 4),

                          ],)
                        ));
                      },
                      child: Text(
                        "Start Assessment",
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18 ),
                        )
                      )
                   )
                    
                ],),
              ),
          floatingActionButton: FloatingActionButton(
          onPressed: () {
                showGeneralDialog(
                context: context,
                barrierColor: Colors.black38,
                barrierLabel: 'Label',
                barrierDismissible: true,
                pageBuilder: (_, __, ___) => Center(
                  child: Container(
                    color: Colors.white,
                    child: Material(
                      color: Colors.transparent,
                      child: Image.asset("assets/images/Logo/instructions.png", width: 500,height: 260,) ,
                    ),
                  ),
                ),
              );
          },
          child: const Icon(
            Icons.info_rounded,
            color: Color.fromARGB(255, 251, 251, 251),
          ),
          backgroundColor: Color.fromARGB(180, 6, 105, 225),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          )
      );
    }
}

class FinalAssessmentEvaluation extends StatelessWidget{

  final int score;
  const FinalAssessmentEvaluation({Key? key , required this.score}) : super(key: key);



  // void openPDF(BuildContext context , File file)
  @override
    Widget build(BuildContext context){
       Color backgroundColor = Color.fromARGB(212, 17, 242, 5);
       String filePath = "assets/documents/mild.pdf";
       String condition = "Mild Condition";
       print(score);
      if(score >=0 && score < 107) {
         backgroundColor = Color.fromARGB(212, 17, 242, 5);
         filePath = "assets/documents/mild.pdf";
         condition = "Mild Condition";
      }else if(score >=107 && score < 214){
         backgroundColor = Color.fromARGB(212, 45, 5, 242);
         filePath = "assets/documents/moderate.pdf";
         condition = "Moderate Condition";
      }else if(score >=214){
         backgroundColor = Color.fromARGB(211, 242, 5, 29);
         filePath = "assets/documents/severe.pdf";
         condition = "Severe Condition";
      }
   
      return (
        Scaffold(
            appBar: AppBar(title: Text("CO19-SMS"),
            ),

            body: Container(
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Logo/background.jpg"),
                fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      color: backgroundColor,
                      boxShadow: [
                        BoxShadow(color:backgroundColor, spreadRadius: 1),
                      ],
                    ),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(condition ,style:TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing:1.1,
                          wordSpacing: 3
                         ),
                        ),
                    )
                  ),
                 Expanded(
                  flex: 8,
                  child: Container(

                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          primary: Color.fromARGB(180, 6, 105, 225),
                          minimumSize: Size(200, 100),
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                    
                          shape: StadiumBorder(),
                          side: BorderSide(
                            width: 1,
                            color: Color.fromARGB(230, 6, 119, 225),
                          ),
                      ),
                      onPressed: () async {
                        // load the pdf file from the assets and view it 
                        final path = filePath;
                        final file = await PDFApi.loadAsset(path);
                        openPDF(context, file);

                      },
                      child: Text(
                        "View PDF",
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 21 ),
                        )
                      )
                  )
                 )

                ],
              )
            )
        )
      );
    }
}
class ButtonCustom extends StatelessWidget{

  final String text;
  final changeYesNoState changeYesNoStateFunc;
  final bool? flag; 
  const ButtonCustom({Key? key,  required this.text , required this.changeYesNoStateFunc , this.flag})  : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: EdgeInsets.only(left: 13 , top: 2 ),
      // margin: EdgeInsets.only(top:10),
      child: this.flag == true ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(180, 6, 105, 225),
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
            
                  shape: StadiumBorder(),
                  side: BorderSide(
                    width: 1,
                    color: Color.fromARGB(230, 6, 119, 225),
                  ),
              ),
              onPressed: () { this.text == "Yes" ? this.changeYesNoStateFunc(true): this.changeYesNoStateFunc(false);},
              child: Text(text)
              ):
              
              OutlinedButton(
                style: TextButton.styleFrom(
                    primary: Color.fromARGB(230, 6, 119, 225),
                    minimumSize: Size(88, 36),
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
              
                    shape: StadiumBorder(),
                    side: BorderSide(
                      width: 1,
                      color: Color.fromARGB(230, 6, 119, 225),
                    ),
                ),
                onPressed: () { this.text == "Yes" ? this.changeYesNoStateFunc(true): this.changeYesNoStateFunc(false);},
                child: Text(text),
              )
    );
  }

}
class QuestionYN extends StatefulWidget {

  final String QuestionName;
  final int id;
  final bool? defaultAnswer;
  final answerQuestionYesNo answerQuestionYesNoFunction;
  const QuestionYN({Key? key,  
                    required this.QuestionName , 
                    required this.id, 
                    required this.answerQuestionYesNoFunction,
                    this.defaultAnswer
                    
                    })  : super(key: key); 

  @override
  State<QuestionYN> createState() => _QuestionYNState();
}
class _QuestionYNState extends State<QuestionYN>{
  bool Background = false;
  bool firstTime = true;
  void _changeBackgound(bool value) {
      setState(() {
        Background = value;
        firstTime = false;
        widget.answerQuestionYesNoFunction(widget.id , Background);
      });
    }

  @override
  Widget build(BuildContext context) {
    if(firstTime){
      Background = (widget.defaultAnswer == true) ? true : false;
    }
    return Column(
        // padding: EdgeInsets.only(left: 10),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10 , bottom: 3),
            
            child: Text(widget.QuestionName, style: TextStyle(   
                fontWeight: FontWeight.w600, // light
                fontSize: 24,
                fontStyle: FontStyle.normal, // italic
                color: Color.fromARGB(255, 3, 60, 112),
            )) ,
          ),
          ButtonCustom(text: "Yes", changeYesNoStateFunc: _changeBackgound , flag : Background),
          ButtonCustom(text: "No", changeYesNoStateFunc: _changeBackgound , flag : !Background),

          SizedBox(height: 5,),
          Divider(
              color: Color.fromARGB(255, 4, 1, 1)
            ),
        ]);
  }
}
class QuestionSlider extends StatefulWidget{
  final String QuestionName;
  final int id;
  final answerQuestionSlider  answerQuestionSliderFunction;
  final List<int>? sliderRange;
  final int? sliderDivisions;
  final double? defaultAnswer;
  const QuestionSlider({Key? key, 
                        required this.QuestionName, 
                        required this.id ,
                        required this.answerQuestionSliderFunction , 
                        required this.sliderRange , 
                        required this.sliderDivisions,
                        this.defaultAnswer
                        })  : super(key: key); 

 @override
  State<QuestionSlider> createState() => _QuestionSliderState();
}
class _QuestionSliderState extends State<QuestionSlider>{
  double sliderValue = -1;



  Widget build(BuildContext context) {
    if(sliderValue == -1){
      if(widget.defaultAnswer != -1){
        if(widget.defaultAnswer != null){
          setState(() {
            sliderValue = widget.defaultAnswer!.toDouble();
          });
          
        }
      }
      else{
        setState(() {
            sliderValue =  widget.sliderRange![0].toDouble();
          });
      }

    }
    return Column(
        // padding: EdgeInsets.only(left: 10),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10 ,top: 2, bottom: 3),
            
            child: Text(widget.QuestionName, style: TextStyle(   
                fontWeight: FontWeight.w600, // light
                fontSize: 24,
                fontStyle: FontStyle.normal, // italic
                color: Color.fromARGB(255, 3, 60, 112),
            )) ,
          ),
        Slider(
          value: sliderValue,
          min: widget.sliderRange![0].toDouble(),
          max: widget.sliderRange![1].toDouble(),
          divisions: widget.sliderDivisions,
          label: sliderValue.toString(),
          thumbColor: Colors.blue,
          inactiveColor: Colors.green,
          activeColor: Colors.red,
          onChanged: (double value) {
            setState(() {
              sliderValue = value;
              widget.answerQuestionSliderFunction(widget.id , value);
            });
          },
      ),
          SizedBox(height: 5,),
          Divider(
              color: Color.fromARGB(255, 4, 1, 1)
            ),
        ]);
  }
}



class ImageQuestion extends StatefulWidget{

  final Question ImageQuesiton;
  const ImageQuestion({Key? key , required this.ImageQuesiton} ) : super(key: key);

  @override
  State<ImageQuestion> createState() => _ImageQuestion();

}
class _ImageQuestion extends State<ImageQuestion>{


  int pageNumber = 0;
  bool pickedPicture = false;
  final _controller = PageController(viewportFraction: 0.8);
  

   void _addAnswerImage(int id) {
    if(widget.ImageQuesiton.imagesPicked.contains(id)){
      widget.ImageQuesiton.imagesPicked.removeWhere((item) => item == id);  
    }else{
      widget.ImageQuesiton.imagesPicked.add(id);
    }
   }


  @override 
  Widget build(BuildContext context){
      return  Column(
            children: [
              Container(
                padding:  EdgeInsets.only(left: 13),
                child: Text(widget.ImageQuesiton.questionName, style: TextStyle(   
                fontWeight: FontWeight.w600, // light
                fontSize: 24,
                fontStyle: FontStyle.normal, // italic
                color: Color.fromARGB(255, 3, 60, 112),)
                ),
              ),
              
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child:  PageView.builder(
                        itemCount: widget.ImageQuesiton.numberOfImages,
                        pageSnapping: true,
                        controller: _controller,
                        onPageChanged: (page) {
                          setState(() {
                            pageNumber = page;
                          });
                        },
                        itemBuilder: (context , pagePosition){
                          if(widget.ImageQuesiton.imagesPicked.contains(pagePosition + 1)){
                            pickedPicture = true;
                          }else{
                             pickedPicture = false;

                          }
                          if(pagePosition+1 == 5 && widget.ImageQuesiton.imageURL![widget.ImageQuesiton.imageURL!.length - 1] == '1'){
                            return SymptomImage(imageURL: widget.ImageQuesiton.imageURL!+"/"+(pagePosition+1).toString()+".jpg", 
                            pressed: pickedPicture,
                            addAnswerImage : _addAnswerImage,
                            id: pagePosition+1);
                          }else{
                            return SymptomImage(imageURL: widget.ImageQuesiton.imageURL!+"/"+(pagePosition+1).toString()+".png", 
                            pressed: pickedPicture,
                            addAnswerImage : _addAnswerImage,
                            id: pagePosition + 1
                            );
                          }
                          
                        },
                      )

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicators(widget.ImageQuesiton.numberOfImages,pageNumber)
                  )
            ],
          );
    }

    List<Widget> indicators(imagesLength,currentIndex) {
      return List<Widget>.generate(imagesLength, (index) {
        return Container(
          margin: EdgeInsets.all(3),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: currentIndex == index ? Colors.black : Colors.black26,
              shape: BoxShape.circle),
        );
      });
    }
}


class SymptomImage extends StatefulWidget{
  final String imageURL;
  final bool pressed;
  final int id;
  final addImageAnswer addAnswerImage;
  const SymptomImage({Key? key , required this.imageURL, required this.pressed , required this.addAnswerImage , required this.id}) : super(key: key);

  @override
  State<SymptomImage> createState() => _SymptomImage();
}
class _SymptomImage extends State<SymptomImage>{
  bool pressed = false;
  bool firstRender = true;
  @override 
  Widget build(BuildContext context){

    if(firstRender){
        firstRender = false;
        pressed = widget.pressed;
    }
    return Container(
      // margin: EdgeInsets.all(2),
      child: Column(
        
        children: [
          //   InkWell(
          //   onTap: () => {
          //   },
          //   splashColor: Colors.white10,
          //   child: Ink.image(
          //       fit: BoxFit.fill,
          //       image: NetworkImage(widget.imageURL)
          //   ) 
          // ),
         GestureDetector(
            onTap: (){

              setState(() {
                pressed = !pressed;
                widget.addAnswerImage(widget.id);
              });
            },
            child:Image.asset(widget.imageURL, width: 500,height: 260,) ,
          ),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.all(3),
            width: 13,
            height: 13,
            decoration: BoxDecoration(
                color: pressed == true? Color.fromARGB(255, 2, 240, 18) : Colors.black26,
                shape: BoxShape.circle),
          )
        ]) 
 
    );
  }
}


class PreHistory extends StatefulWidget {
  // This widget is the root of your application.
  List<Question> Questions;
  PreHistory({ Key? key, required this.Questions }) : super(key: key);
  
  @override
  State<PreHistory> createState() => _PreHistory();

}
class _PreHistory extends State<PreHistory>{

@override
Widget build(BuildContext context) {

    List<Question> questionsList = widget.Questions;
    final questionSet = <Widget>{};
    void _changeanswerQuestionYesNo(int id , bool value) {
          setState(() {
            questionsList[id].answered = value;
          });
        }

    void _changeanswerQuestionSlider(int id , double value){
      setState(() {
        questionsList[id].sliderAnswer = value;
        questionsList[id].answered = true;
      });
    }
  
    for(int i = 0; i<questionsList.length; i++){
        
        for(int j = 0; j<questionsList.length;j++){
          if(questionsList[i].id == questionsList[j].parentId){
            questionsList[j].view = questionsList[i].answered;
          }
          
        }
        // set the answer of the question of the type 1 (yes or no question)
        if(questionsList[i].questionType == 1){
          if(questionsList[i].answered == true){
            questionsList[i].answer = "yes";
          }else{
            questionsList[i].answer = "no";
          }
        }
    }

    for (int i = 0; i<questionsList.length; i++){
      if(questionsList[i].view == false) continue;
      if(questionsList[i].questionType == 1){
        questionSet.add(QuestionYN(QuestionName: questionsList[i].questionName , 
                                    id : i , 
                                    answerQuestionYesNoFunction: (int id , bool value) => _changeanswerQuestionYesNo(i , value),
                                    defaultAnswer : questionsList[i].answered
                                    ));
        
      }else if( questionsList[i].questionType == 4){
        questionSet.add(MultipleQuestions(choiceQuestion: questionsList[i]));    
      }

     
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("Pre History"),
        ),
      body: Container(
        decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Logo/background.jpg"),
                fit: BoxFit.cover,
                ),
              ),
        child:        ListView(children: questionSet.toList().map((e) {
        return Column(
          children: [
              SizedBox(height: 25,),
              e,
              
          ],
        );
      }).toList(),
        ),
      ),
      

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Try(
                                            symptoms: [
                                              majorSymptoms(title: "Fever" , questions: [
                                                  Question(questionName: "Do you have chills or Shivering?", id: 1, questionType:1 , rightAnswer: "yes", score: 1),
                                                  Question(questionName: "Do you have sweating?", id: 2, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel thirsty?", id: 3, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Did you measure your temperature recently?", id: 4, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "What is your temprature recently?", id: 4001, questionType:2 , score: 1, view: false, parentId: 4 , subQuesiton: true , sliderRange: [37,42] , sliderDivisions: 10),
                                                  Question(questionName: "Did you receive a dose of COVID-19 vaccine in the last 3 weeks ?", score: 1, rightAnswer: "no", id: 5, questionType:1  ),
                                              ]),
                                              majorSymptoms(title: "Cough" , questions: [
                                                  Question(questionName: "How long are you experiencing cough?", id: 6, questionType:4, score: 1 ,scores: [2 , 4], multipleChoices: ["Less than 4 weeks" , "more than 4 weeks"]),
                                                  Question(questionName: "Do you suffer from any chronic pulmonary disease?", id: 7, questionType:1,  score: 4, rightAnswer: "yes"),
                                                  Question(questionName: "Are you a smoker ?", id: 8, questionType:1,  score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Do you experince Dry cough or wet cough ?", id: 9, questionType:4, score: 1 ,  scores: [2 , 2], multipleChoices: ["Dry" , "Wet"]),
                                                  Question(questionName: "Do you release any mucus or blood just by clearing your throat ?", id: 10, questionType:1, score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Does your breathing give off a wheezing ?", id: 11, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you experince pain in your chest?", id: 12, questionType:1 , score: 4, rightAnswer: "yes"),
                                                  Question(questionName: "Where is your chest pain located ?", id: 12001, questionType:3, score: 1 , view: false, parentId: 12 , subQuesiton: true, imageURL: "assets/images/Group2", numberOfImages: 5),
                                                  Question(questionName: "What is your temprature recently?", id: 12002, questionType:1, score: 2, rightAnswer: "no" , view: false, parentId: 12 , subQuesiton: true ),
                                              ]),
                                              majorSymptoms(title: "Tiredness and fatigue" , questions: [
                                                  Question(questionName: "Did you receive a dose of COVID-19 vaccine in the last 3 weeks ?", id: 13, questionType:1, score: 2, rightAnswer: "no"),
                                                  Question(questionName: "Do you experince general muscle weakness?", id: 14, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you have diabetes or a high blood sugar level ?", id: 15, questionType:1,score: 4, rightAnswer: "yes"),
                                                  Question(questionName: "Do you have a fever ?", id: 16, questionType:1, score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel a generalized pain in your muscles ?", id: 17, questionType:1 , score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Do you have pain in any of your joints ?", id: 18, questionType:1 , score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Where is your joint pain located ?", id: 18001, questionType:3, score: 1 , view: false, parentId: 18 , subQuesiton: true,imageURL: "assets/images/Group3", numberOfImages: 9 ),
                                                  Question(questionName: "What is your temprature recently?", id: 18002, questionType:1, score: 1, rightAnswer: "yes", view: false, parentId: 18 , subQuesiton: true ),
                                              ]),
                                              majorSymptoms(title: "Breathing difficults or Shortness of breath" , questions: [
                                                  Question(questionName: "How long have you been having breathing difficulties or a shortness of breath ?", id: 19, scores: [20,30,50],questionType:4, score: 1 , multipleChoices: ["Several days", "from 1-4 weeks","more than 4 weeks"]),
                                                  Question(questionName: "Does your shortness of breath occur or worsen when you exert yourself in a physical activity?", score: 10, rightAnswer: "yes", id: 20, questionType:1),
                                                  Question(questionName: "Did your shortness of breath start suddenly ?", id: 21, questionType:1, score:10, rightAnswer: "yes"),
                                                  Question(questionName: "Do you smoke or exposed to second-hand smoking or were a smoker for a long period of time", score: 1, rightAnswer: "yes", id: 0001, questionType:1),
                                                  Question(questionName: "even if you have quit now ?", id: 22, questionType:1, score: 4, rightAnswer: "yes"),
                                                  Question(questionName: "Have you recently been in contact with a person who has been infected with covid-19 ?", score: 10, rightAnswer: "yes", id: 23, questionType:1 ),

                                              ]),
                                              majorSymptoms(title: "Loss of taste or smell" , questions: [
                                                  Question(questionName: "Has your nose recently been getting congested? ", id: 24, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you have a runny nose ?", id: 25, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel pressure on your face ?", id: 26, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel pain in your face ?", id: 26001, questionType:1 , score: 1, rightAnswer: "yes", view: false, parentId: 26 , subQuesiton: true ),
                                                  Question(questionName: "Do you feel headache ?", id: 27, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Where is your headache located ?", id: 27001, questionType:3, score: 1 , view: false, parentId: 27 , subQuesiton: true,imageURL: "assets/images/Group4", numberOfImages: 8 ),
                                                  Question(questionName: "Have you been snoring ?", id: 28, questionType:1, score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Have you recently been in contact with a person who has been infected with covid-19 ?", id: 29, questionType:1, score: 10, rightAnswer: "yes"),
                                                  Question(questionName: "How long have you been having loss of taste or smell ?", id: 30, scores:[2,4,10] , questionType:4, score: 1 , multipleChoices: ["Several days", "from 1-4 weeks","more than 4 weeks"]),
                                              ]),
                                              majorSymptoms(title: "Sore throat" , questions: [
                                                  Question(questionName: "Do you experince difficulty in swallowing for more than 2 weeks ?", id: 31, questionType:1, score: 2, rightAnswer: "yes"),
                                                  Question(questionName: "Do your swallowing difficulties occur with solids only ?", id: 31001, questionType:1, score: 1, rightAnswer: "no" , view: false, parentId: 31 , subQuesiton: true ),
                                                  Question(questionName: "Do you have any ulcers in your mouth ?", id: 32, questionType:1, score: 1, rightAnswer: "yes"),

                                              ]),
                                              majorSymptoms(title: "Headache" , questions: [
                                                  Question(questionName: "Do you feel headache ?", id: 33, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Where is your headache located ?", id: 33001, questionType:3, score: 1 , view: false, parentId: 33 , subQuesiton: true,imageURL: "assets/images/Group4", numberOfImages: 8 ),
                                                  Question(questionName: "Has your nose recently been getting congested? ", id: 34, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you have a runny nose ?", id: 35, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Have you been snoring ?", id: 36, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Have you been sneezing a lot ?", id: 37, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel a generalized pain in your muscles ?", id: 38, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Have you recently been feeling an unusual general or focal weakness, exhaustion or fatigue ?", id: 39, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Does your headache come and go ?", id: 40, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel pressure on your face ?", id: 41, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you feel pain in your face ?", id: 42, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Did your headache start suddenly ?", id: 43, questionType:1, score: 1, rightAnswer: "yes"),
                                                  
                                              ]),

                                              majorSymptoms(title: "Abdominal pain and disorders" , questions: [
                                                  Question(questionName: "Where is your abdominal pain located?", id: 45, questionType:3, score: 1 , imageURL: "assets/images/Group1", numberOfImages: 9 ),
                                                  Question(questionName: "Have you been having diarrhea ?", id: 46, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you live in an area of poor sanitation or did you recently drink or eat contaminated food or water ?", id: 47, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Does it hurt when you touch or apply pressure anywhere on your abdomen ? ", id: 48, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Where is your abdominal tenderness located?", id: 48001, questionType:3, score: 1 , view: false, parentId: 48 , subQuesiton: true,imageURL: "assets/images/Group1", numberOfImages: 9 ),
                                                  Question(questionName: "Are your stools pale / light in color ?", id: 49, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Has your abdominal pain been gradually increasing ?", id: 50, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Is your abdominal pain steady in nature ? ", id: 51, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you have anorexia or have you been experiencing a lack or loss of appetite ? ", id: 52, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Have you recently vomited ? ", id: 53, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Did your abdominal pain start suddenly ?", id: 54, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Is your abdominal pain severe in intensity ?", id: 55, questionType:1, score: 1, rightAnswer: "yes"),
                                              ]),
                                              majorSymptoms(title: "Chest pain" , questions: [

                                                  
                                                  Question(questionName: "Do you experince pain in your chest?", id: 56, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Where is your chest pain located ?", id: 57, questionType:3, score: 1 ,imageURL: "assets/images/Group2", numberOfImages: 5 ),
                                                  Question(questionName: "Did you recently suffer from an injury or trauma to the chest?", id: 58, questionType:1, score: 1, rightAnswer: "yes"),
                                                  Question(questionName: "Do you suffer from any chronic pulmonary diseases?  ", id: 59, questionType:1, score: 10, rightAnswer: "yes"),
                                                  Question(questionName: "How would you describe the intensity of the pain or discomfort?", id: 60, questionType:4, score: 1 , scores: [0 , 2 , 4],multipleChoices: ["Mild ( doesn’t interfere with daily activities)","Moderate (some daily activities are limited)","Severe ( cannot perform any daily activities)"]),
                                                  Question(questionName: "How does taking a deep breath affect the pain or discomfort ?", id: 61, questionType:4, score: 1 , scores: [20 , 0],multipleChoices: ["Worsens","No effect"]),
                                                  Question(questionName: "Do you have difficulty breathing ?", id: 62, questionType:1, score: 20, rightAnswer: "yes"),
                                                  Question(questionName: "How bad is the breathlessness ?", id: 62001, view: false, parentId: 62 , subQuesiton: true , questionType:4, score: 1 ,scores: [1 , 30 , 50], multipleChoices: ["Mild ( doesn’t interfere with daily activities)","Moderate (some daily activities are limited)","Severe ( cannot perform any daily activities)"]),
                                                  Question(questionName: "Does it tend to get worse when lying down ? ", id: 63, questionType:1, score: 50, rightAnswer: "yes"),
                                                  Question(questionName: "How are your symptoms changing over time ?", id: 64, questionType:1,score: 20, rightAnswer: "yes"),
                                                  Question(questionName: "How are your symptoms changing over time ?", id: 65, questionType:4, score: 1 ,scores: [50 , 15 , 10], multipleChoices: ["They are getting worse","They are not as bad as they were","they are staying about the same"]),
                                              ]),

                                            ],
                                          ),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(
                    arguments: widget.Questions,
                  ),
                ),
          );
        },
        child: const Icon(
          Icons.next_plan,
          color: Color.fromARGB(255, 250, 250, 250),
        ),
        backgroundColor: Colors.green,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
       );
  }
}


class MultipleQuestions extends StatefulWidget {

  final Question choiceQuestion;
  const MultipleQuestions({Key? key,  required this.choiceQuestion})  : super(key: key); 

  @override
  State<MultipleQuestions> createState() => _MultipleQuestions();
}
class _MultipleQuestions extends State<MultipleQuestions>{
  bool Background = false;
  bool firstTime = true;
  List<Widget> choices = [];

  void _setChoice(String answer){
    setState(() {
        Background = !Background;
        choices = [];
      });
    widget.choiceQuestion.answer = answer;
    widget.choiceQuestion.answered = true;
  }
  void _clearChoice(){
      setState(() {
        Background = !Background;
        choices = [];
      });
    widget.choiceQuestion.answer = '';
    widget.choiceQuestion.answered = false;
  }
  
  @override
  Widget build(BuildContext context) {
    choices = [];
    for(int i = 0; i< widget.choiceQuestion.multipleChoices!.length;i++ ){
      bool flag=false;
      if (widget.choiceQuestion.multipleChoices![i] == widget.choiceQuestion.answer){
        flag = true;
      }
      choices.add(
        ChoiceQuestion(
          text: widget.choiceQuestion.multipleChoices![i] ,
          flag: flag,
          setChoice : _setChoice,
          clearChoice: _clearChoice,
        )
      );
    }

    return Column(
        // padding: EdgeInsets.only(left: 10),
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10 , bottom: 3),
            
            child: Text(widget.choiceQuestion.questionName, style: TextStyle(   
                fontWeight: FontWeight.w600, // light
                fontSize: 24,
                fontStyle: FontStyle.normal, // italic
                color: Color.fromARGB(255, 3, 60, 112),
            )) ,

          ),
          ...choices,
          SizedBox(height: 5,),
          Divider(
              color: Color.fromARGB(255, 4, 1, 1)
            ),
        ]);
  }
}



class ChoiceQuestion extends StatelessWidget{
  

  final String text;
  final bool flag;
  final setChoiceFunction setChoice;
  final clearChoiceFunction clearChoice;
  const ChoiceQuestion({Key? key,  required this.text , required this.flag , required this.setChoice, required this.clearChoice})  : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return 
    Container(
      padding: EdgeInsets.only(left: 13 , top: 2 ),
      // margin: EdgeInsets.only(top:10),
      child: this.flag == true ? ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(180, 6, 105, 225),
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 30.0),
            
                  shape: StadiumBorder(),
                  side: BorderSide(
                    width: 1,
                    color: Color.fromARGB(230, 6, 119, 225),
                  ),
              ),
              onPressed: () {
                clearChoice();
                },
              child: Text(text)
              ):
              
              OutlinedButton(
                style: TextButton.styleFrom(
                    primary: Color.fromARGB(230, 6, 119, 225),
                    minimumSize: Size(88, 36),
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
              
                    shape: StadiumBorder(),
                    side: BorderSide(
                      width: 1,
                      color: Color.fromARGB(230, 6, 119, 225),
                    ),
                ),
                onPressed: () {
                  setChoice(text);
                  },
                child: Text(text),
              )
    );
  }

}




// for PDF reader
class PDFViewerPage extends StatefulWidget{
  final File file;
  const PDFViewerPage({Key? key , required this.file}) :super(key:key);

  @override
  State<PDFViewerPage> createState() => _PDFViewerPage();
}
class _PDFViewerPage extends State<PDFViewerPage>{

  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);

    return (
      Scaffold(
        appBar: AppBar(
          title: Text(name),
        ),
        body: PDFView(
          filePath: widget.file.path,
        ),
      )
    );
  }
}

void openPDF(BuildContext context , File file) => Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => PDFViewerPage(file: file))
);

class PDFApi {
  static Future<File> loadAsset(String path) async {
    final data = await rootBundle.load(path);
    final bytes = data.buffer.asUint8List();

    return _storeFile(path, bytes);
  }

   static Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}