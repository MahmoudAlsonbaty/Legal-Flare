import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAppUser extends Equatable {
  final String userID;
  final String email;
  final bool confirmedEmail;
  final String name;
  final DateTime dateOfBirth;
  final String maritalStatus;
  final String jobStatus;

  MyAppUser(
      {required this.dateOfBirth,
      required this.maritalStatus,
      required this.jobStatus,
      required this.userID,
      required this.email,
      required this.confirmedEmail,
      required this.name});

  MyAppUser copyWith(
      {String? userID,
      String? email,
      bool? confirmedEmail,
      String? name,
      DateTime? dateOfBirth,
      String? maritalStatus,
      String? jobStatus}) {
    return MyAppUser(
        userID: userID ?? this.userID,
        email: email ?? this.email,
        name: name ?? this.name,
        jobStatus: jobStatus ?? this.jobStatus,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        confirmedEmail: confirmedEmail ?? this.confirmedEmail);
  }

  MyAppUser.empty()
      : userID = "",
        email = "",
        confirmedEmail = false,
        name = "",
        dateOfBirth = DateTime(1900),
        maritalStatus = "",
        jobStatus = "";

  bool get isEmpty => userID.isEmpty && email.isEmpty;
  bool get hasInfo =>
      name.isNotEmpty &&
      !dateOfBirth.isAtSameMomentAs(DateTime(1900)) &&
      maritalStatus.isNotEmpty &&
      jobStatus.isNotEmpty;

  //for Firebase Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': userID,
      'email': email,
      'confirmedEmail': confirmedEmail,
      'name': name,
      'DOB': dateOfBirth,
      'job': jobStatus,
      'maritalStatus': maritalStatus
    };
  }

  factory MyAppUser.fromMap(Map<String, dynamic> map) {
    DateTime dob;
    if (map['DOB'].runtimeType == DateTime) {
      dob = map['DOB'];
    } else {
      dob = (map['DOB'] as Timestamp).toDate();
    }
    return MyAppUser(
      userID: map['uid'],
      email: map['email'],
      confirmedEmail: map['confirmedEmail'],
      name: map['name'],
      maritalStatus: map['maritalStatus'],
      jobStatus: map['job'],
      dateOfBirth: dob,
    );
  }

  factory MyAppUser.fromFirebaseUser(User user) {
    return MyAppUser(
      userID: user.uid,
      email: user.email ?? "",
      confirmedEmail: user.emailVerified,
      name: user.displayName ?? "",
      dateOfBirth: DateTime(1900),
      maritalStatus: '',
      jobStatus: '',
    );
  }
/*
  @override
  String toString() {
    return "";
  }
*/
  @override
  List<Object?> get props => [
        userID,
        email,
        confirmedEmail,
        name,
        dateOfBirth,
        jobStatus,
        maritalStatus
      ];
}
