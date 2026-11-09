import '../models/quiz_question.dart';

const List<String> quizCategories = [
  'Movies',
  'Actors',
  'Directors',
  'Music',
  'Blockbusters',
  'Hardcore Tollywood',
];

const Map<String, List<QuizQuestion>> questionBank = {
  'Movies': [
    QuizQuestion(
      question: 'Which Telugu film directed by S. S. Rajamouli was released in 2022?',
      options: ['RRR', 'Eega', 'Magadheera', 'Maryada Ramanna'],
      correctIndex: 0,
      explanation: 'RRR was directed by S. S. Rajamouli and released in 2022.',
    ),
    QuizQuestion(
      question: 'Which film tells the story of a man who returns as a housefly?',
      options: ['Eega', 'Jersey', 'Athadu', 'Leader'],
      correctIndex: 0,
      explanation: 'Eega is the fantasy film built around a character who is reborn as a housefly.',
    ),
    QuizQuestion(
      question: 'Which film introduces the fictional kingdom of Mahishmati?',
      options: ['Baahubali', 'Pushpa', 'Arjun Reddy', 'Fidaa'],
      correctIndex: 0,
      explanation: 'Mahishmati is the fictional kingdom in the Baahubali films.',
    ),
    QuizQuestion(
      question: 'Who directed Pushpa: The Rise?',
      options: ['Sukumar', 'Trivikram Srinivas', 'Koratala Siva', 'Boyapati Srinu'],
      correctIndex: 0,
      explanation: 'Pushpa: The Rise was directed by Sukumar.',
    ),
    QuizQuestion(
      question: 'Which film features the characters Komaram Bheem and Alluri Sitarama Raju?',
      options: ['RRR', 'Baahubali', 'Rangasthalam', 'Pokiri'],
      correctIndex: 0,
      explanation: 'RRR imagines a fictional meeting between the two historical figures.',
    ),
  ],
  'Actors': [
    QuizQuestion(
      question: 'Who portrays Komaram Bheem in RRR?',
      options: ['Jr. NTR', 'Ram Charan', 'Prabhas', 'Allu Arjun'],
      correctIndex: 0,
      explanation: 'Jr. NTR plays Komaram Bheem in RRR.',
    ),
    QuizQuestion(
      question: 'Who portrays Alluri Sitarama Raju in RRR?',
      options: ['Ram Charan', 'Jr. NTR', 'Nani', 'Rana Daggubati'],
      correctIndex: 0,
      explanation: 'Ram Charan plays Alluri Sitarama Raju in RRR.',
    ),
    QuizQuestion(
      question: 'Which actor plays Pushpa Raj in Pushpa: The Rise?',
      options: ['Allu Arjun', 'Mahesh Babu', 'Naga Chaitanya', 'Vijay Deverakonda'],
      correctIndex: 0,
      explanation: 'Allu Arjun plays the title character, Pushpa Raj.',
    ),
    QuizQuestion(
      question: 'Who plays the central Baahubali character in the Baahubali films?',
      options: ['Prabhas', 'Ram Pothineni', 'Nithiin', 'Gopichand'],
      correctIndex: 0,
      explanation: 'Prabhas plays the central Baahubali characters across the films.',
    ),
    QuizQuestion(
      question: 'Who is the lead actor in Geetha Govindam?',
      options: ['Vijay Deverakonda', 'Sharwanand', 'Nani', 'Sai Dharam Tej'],
      correctIndex: 0,
      explanation: 'Vijay Deverakonda stars as Vijay Govind in Geetha Govindam.',
    ),
  ],
  'Directors': [
    QuizQuestion(
      question: 'Who directed Baahubali: The Beginning?',
      options: ['S. S. Rajamouli', 'Sukumar', 'Puri Jagannadh', 'V. V. Vinayak'],
      correctIndex: 0,
      explanation: 'Baahubali: The Beginning was directed by S. S. Rajamouli.',
    ),
    QuizQuestion(
      question: 'Who directed Pushpa: The Rise?',
      options: ['Sukumar', 'Anil Ravipudi', 'Vamsi Paidipally', 'Sandeep Reddy Vanga'],
      correctIndex: 0,
      explanation: 'Sukumar directed Pushpa: The Rise.',
    ),
    QuizQuestion(
      question: 'Who directed the Telugu film Rangasthalam?',
      options: ['Sukumar', 'S. S. Rajamouli', 'Krish Jagarlamudi', 'Sekhar Kammula'],
      correctIndex: 0,
      explanation: 'Rangasthalam was directed by Sukumar.',
    ),
    QuizQuestion(
      question: 'Who directed Athadu?',
      options: ['Trivikram Srinivas', 'Srinu Vaitla', 'Puri Jagannadh', 'Boyapati Srinu'],
      correctIndex: 0,
      explanation: 'Athadu was directed by Trivikram Srinivas.',
    ),
    QuizQuestion(
      question: 'Who directed the Telugu fantasy film Arundhati?',
      options: ['Kodi Ramakrishna', 'Gunasekhar', 'Raghavendra Rao', 'Teja'],
      correctIndex: 0,
      explanation: 'Arundhati was directed by Kodi Ramakrishna.',
    ),
  ],
  'Music': [
    QuizQuestion(
      question: 'Who composed the music for RRR?',
      options: ['M. M. Keeravani', 'Devi Sri Prasad', 'S. Thaman', 'Gopi Sundar'],
      correctIndex: 0,
      explanation: 'M. M. Keeravani composed the music for RRR.',
    ),
    QuizQuestion(
      question: 'Who is the music director of Pushpa: The Rise?',
      options: ['Devi Sri Prasad', 'M. M. Keeravani', 'S. Thaman', 'Anirudh Ravichander'],
      correctIndex: 0,
      explanation: 'Devi Sri Prasad composed the music for Pushpa: The Rise.',
    ),
    QuizQuestion(
      question: 'Who composed the music for the Baahubali films?',
      options: ['M. M. Keeravani', 'Mani Sharma', 'Harris Jayaraj', 'S. Thaman'],
      correctIndex: 0,
      explanation: 'M. M. Keeravani composed the music for the Baahubali films.',
    ),
    QuizQuestion(
      question: 'Who composed the music for Ala Vaikunthapurramuloo?',
      options: ['S. Thaman', 'Devi Sri Prasad', 'Mickey J. Meyer', 'Gopi Sundar'],
      correctIndex: 0,
      explanation: 'S. Thaman composed the music for Ala Vaikunthapurramuloo.',
    ),
    QuizQuestion(
      question: 'Who composed the music for Eega?',
      options: ['M. M. Keeravani', 'Devi Sri Prasad', 'S. Thaman', 'Ilaiyaraaja'],
      correctIndex: 0,
      explanation: 'M. M. Keeravani composed the music for Eega.',
    ),
  ],
  'Blockbusters': [
    QuizQuestion(
      question: 'Which Telugu film features the song Naatu Naatu?',
      options: ['RRR', 'Pushpa', 'Baahubali 2', 'Ala Vaikunthapurramuloo'],
      correctIndex: 0,
      explanation: 'Naatu Naatu is from the film RRR.',
    ),
    QuizQuestion(
      question: 'Which film features Allu Arjun as Pushpa Raj?',
      options: ['Pushpa: The Rise', 'Ala Vaikunthapurramuloo', 'Race Gurram', 'Sarrainodu'],
      correctIndex: 0,
      explanation: 'Allu Arjun plays Pushpa Raj in Pushpa: The Rise.',
    ),
    QuizQuestion(
      question: 'In which film does Ram Charan play Chitti Babu?',
      options: ['Rangasthalam', 'Magadheera', 'Dhruva', 'Yevadu'],
      correctIndex: 0,
      explanation: 'Ram Charan plays Chitti Babu in Rangasthalam.',
    ),
    QuizQuestion(
      question: 'Which film centres on a man reborn as a housefly?',
      options: ['Eega', 'Mahanati', 'Jersey', 'Anukokunda Oka Roju'],
      correctIndex: 0,
      explanation: 'Eega uses the housefly reincarnation premise as its central story idea.',
    ),
    QuizQuestion(
      question: 'Which film series is set partly in the kingdom of Mahishmati?',
      options: ['Baahubali', 'Karthikeya', 'F2', 'Manam'],
      correctIndex: 0,
      explanation: 'Mahishmati is the setting of the Baahubali story.',
    ),
  ],
  'Hardcore Tollywood': [
    QuizQuestion(
      question: 'Who produced RRR under the DVV Entertainment banner?',
      options: ['D. V. V. Danayya', 'Shobu Yarlagadda', 'Allu Aravind', 'Dil Raju'],
      correctIndex: 0,
      explanation: 'RRR was produced by D. V. V. Danayya under DVV Entertainment.',
    ),
    QuizQuestion(
      question: 'Who wrote the original story for RRR?',
      options: ['V. Vijayendra Prasad', 'S. S. Rajamouli', 'Sai Madhav Burra', 'Trivikram Srinivas'],
      correctIndex: 0,
      explanation: 'V. Vijayendra Prasad is credited with the story of RRR.',
    ),
    QuizQuestion(
      question: 'Who edited RRR?',
      options: ['A. Sreekar Prasad', 'Kotagiri Venkateswara Rao', 'Marthand K. Venkatesh', 'Naveen Nooli'],
      correctIndex: 0,
      explanation: 'A. Sreekar Prasad is credited as the editor of RRR.',
    ),
    QuizQuestion(
      question: 'Who was the cinematographer of Baahubali: The Beginning?',
      options: ['K. K. Senthil Kumar', 'R. Rathnavelu', 'P. S. Vinod', 'Shyam K. Naidu'],
      correctIndex: 0,
      explanation: 'K. K. Senthil Kumar was the cinematographer for Baahubali: The Beginning.',
    ),
    QuizQuestion(
      question: 'Who was the cinematographer for Pushpa: The Rise?',
      options: ['Miroslaw Kuba Brozek', 'K. K. Senthil Kumar', 'R. Rathnavelu', 'D. V. Manikandan'],
      correctIndex: 0,
      explanation: 'Miroslaw Kuba Brozek served as cinematographer for Pushpa: The Rise.',
    ),
  ],
};
