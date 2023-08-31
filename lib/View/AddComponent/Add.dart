import 'dart:typed_data';
import 'package:coocklen/View/AddComponent/EtapeAdd.dart';
import 'package:coocklen/View/AddComponent/IngredientAdd.dart';
import 'package:coocklen/View/AddComponent/PrevisuAdd/PrevisuAdd.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:coocklen/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';

class AppbarAdd extends StatelessWidget {
  const AppbarAdd({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 2,
      title: Center(
        child: const Text(
          "Ajoutons une recette",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      backgroundColor: Colors.pink,
    );
  }
}

// ignore: must_be_immutable
class BodyAdd extends StatefulWidget {
  Uint8List? profilpic;
  Map<String, dynamic> userdata = {};
  BodyAdd({
    Key? key,
    required this.profilpic,
    required this.userdata,
  }) : super(key: key);
  @override
  State<BodyAdd> createState() => _BodyAddState();
}

class _BodyAddState extends State<BodyAdd> {
  @override
  void initState() {
    super.initState();
    GetStart();
  }

  Uint8List? Addpicture;
  Uint8List? AddPicture2;
  TextEditingController title = TextEditingController();
  double rating = 1;
  int number = 5;
  bool start = false;
  TextEditingController time = TextEditingController();

  // ingredient component
  List<String> Ingredient = [];
  List<double> Quantite = [];
  List<String> unitList = [];
  TextEditingController IngredientTitle = TextEditingController();
  TextEditingController IngredientContent = TextEditingController();
  TextEditingController unit = TextEditingController();
  // Etape component
  List<String> StepTitleList = [];
  List<String> StepList = [];
  TextEditingController StepTitle = TextEditingController();
  TextEditingController Step = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (Addpicture != null)
                    Container(
                      height: 150,
                      width: 120,
                      child: ElevatedButton(
                          onPressed: () {
                            SyncPicture();
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17.5))),
                          child: Container(
                            height: 150,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(17.5),
                              child: Image.memory(
                                Addpicture!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )),
                    ),
                  SizedBox(
                    width: 35,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Titre de la recette :",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 180,
                        height: 50,
                        child: TextField(
                          controller: title,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "Entrez vôtre titre",
                            hintStyle:
                                TextStyle(fontSize: 15, color: Colors.pink),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blueGrey.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(17.5)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink),
                                borderRadius: BorderRadius.circular(17.5)),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Niveau de difficulté :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  RatingBar.builder(
                    minRating: 1,
                    updateOnDrag: true,
                    itemSize: 25,
                    itemBuilder: (context, index) {
                      return Text(
                        "🌶️",
                        style: TextStyle(
                          fontSize: 30,
                          color: index < rating ? Colors.amber : Colors.grey,
                        ),
                      );
                    },
                    onRatingUpdate: (rating) => setState(() {
                      this.rating = rating;
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 45,
                width: 270,
                child: TextField(
                  controller: time,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Temps de préparation en minutes",
                    hintStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.pink,
                    ),
                    contentPadding: EdgeInsets.only(top: 3),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(14.5)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.pink),
                        borderRadius: BorderRadius.circular(14.5)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Ajoutez vos ingrédients pour $number personnes:",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  content: Container(
                                    height: 205,
                                    width: 400,
                                    child: IngredientAdd(
                                      title: IngredientTitle,
                                      content: IngredientContent,
                                      unit: unit,
                                      ingredient: Ingredient,
                                      quantite: Quantite,
                                      unitList: unitList,
                                      opentype: 0,
                                    ),
                                  ),
                                );
                              }).then((_) {
                            setState(() {});
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.add_circled,
                          size: 35,
                          color: Colors.pink,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 80,
                    child: ListView.builder(
                        itemCount: Ingredient.length,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          content: Container(
                                            height: 205,
                                            width: 400,
                                            child: IngredientAdd(
                                              title: IngredientTitle,
                                              content: IngredientContent,
                                              unit: unit,
                                              ingredient: Ingredient,
                                              quantite: Quantite,
                                              unitList: unitList,
                                              opentype: 1,
                                              index: index,
                                            ),
                                          ),
                                        );
                                      }).then((_) {
                                    setState(() {});
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.5),
                                  ),
                                  backgroundColor: Color(0xFFECECEC),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.5),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            Ingredient[index],
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink),
                                          ),
                                          Divider(
                                            color: Colors.pink,
                                            indent: 5,
                                            endIndent: 5,
                                          ),
                                          Text(
                                            "${Quantite[index].round().toString()} ${unitList[index]}",
                                            style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.pink),
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Text(
                  "Ajoutez les étapes de préparation :",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  content: Container(
                                    height: 270,
                                    width: 400,
                                    child: EtapeAdd(
                                        StepTitleList: StepTitleList,
                                        StepList: StepList,
                                        StepTitle: StepTitle,
                                        Step: Step,
                                        opentype: 0),
                                  ),
                                );
                              }).then((_) {
                            setState(() {});
                          });
                        },
                        icon: Icon(
                          CupertinoIcons.add_circled,
                          size: 35,
                          color: Colors.pink,
                        )),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    height: 50,
                    child: ListView.builder(
                        itemCount: StepTitleList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: SizedBox(
                              height: 35,
                              width: 70,
                              child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            content: Container(
                                              height: 270,
                                              width: 400,
                                              child: EtapeAdd(
                                                StepTitleList: StepTitleList,
                                                StepList: StepList,
                                                StepTitle: StepTitle,
                                                Step: Step,
                                                opentype: 1,
                                                index: index,
                                              ),
                                            ),
                                          );
                                        }).then((_) {
                                      setState(() {});
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Color(0xFFECECEC),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(9.5),
                                    ),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9.5),
                                      child: Center(
                                          child: Text(
                                        StepTitleList[index],
                                        style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold),
                                      )))),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            height: 60,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          reset();
                        },
                        child: Text(
                          "Effacer",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.5))),
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    SizedBox(
                      height: 45,
                      width: 120,
                      child: ElevatedButton(
                        onPressed: () {
                          Suivant();
                        },
                        child: Text(
                          "Suivant",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.5))),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
          elevation: 0,
        ));
  }

  void GetStart() async {
    try {
      Reference picture =
          await storage.ref().child("Recettes/Default/AddImage.jpg");
      final temp2 = await picture.getData(10 * 1024 * 1024);
      setState(() {
        Addpicture = temp2;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> SyncPicture() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // crop
    if (image != null) {
      final ImageCropper _imageCropper = ImageCropper();
      CroppedFile? croppedImage = await _imageCropper.cropImage(
          cropStyle: CropStyle.rectangle,
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square
          ],
          uiSettings: [
            AndroidUiSettings(
              lockAspectRatio: false,
            ),
            IOSUiSettings(
              cancelButtonTitle: 'Annuler',
              doneButtonTitle: 'Terminer',
              aspectRatioLockEnabled: false,
            ),
          ]);
      if (croppedImage != null) {
        // send and set
        try {
          Uint8List temp = await croppedImage.readAsBytes();
          setState(() {
            Addpicture = temp;
          });
        } catch (error) {
          print(error);
        }
      }
    }
  }

  void reset() {
    setState(() {
      title.text = "";
      rating = 1;
      Ingredient = [];
      Quantite = [];
      IngredientTitle.text = "";
      IngredientContent.text = "";
      StepTitleList = [];
      StepList = [];
      StepTitle.text = "";
      Step.text = "";
    });
    GetStart();
  }

  void Suivant() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PrevisuAdd(
                title: title,
                profilpic: widget.profilpic,
                userdata: widget.userdata,
                Addpicture: Addpicture,
                AddPicture2: AddPicture2,
                rating: rating,
                Ingredient: Ingredient,
                Quantite: Quantite,
                StepTitleList: StepTitleList,
                StepList: StepList,
                number: number,
                unitList: unitList,
                time: time)));
  }
}
