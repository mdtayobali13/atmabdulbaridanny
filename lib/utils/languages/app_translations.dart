import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class AppTranslations {
  final bool isBangla;

  const AppTranslations(this.isBangla);

  static AppTranslations of(bool isBangla) => AppTranslations(isBangla);

  // -------------------------------------------------------------
  // Common & Generic
  // -------------------------------------------------------------
  String get appTitle => isBangla ? "ব্যারিস্টার কায়সার কামাল, এমপি" : "Barrister Kayser Kamal, MP";
  String get todayVisitor => isBangla ? "আজকের ভিজিটর" : "Today Visitor";
  String get totalVisitor => isBangla ? "মোট ভিজিটর" : "Total Visitor";
  String get totalVisitsTitle => isBangla ? "মোট ভিজিট" : "Total Visits";
  String get readMore => isBangla ? "বিস্তারিত পড়ুন" : "Read More";
  String get seeMore => isBangla ? "আরও দেখুন" : "See More";
  String get failedToLoad => isBangla ? "লোড করতে ব্যর্থ হয়েছে" : "Failed to load";
  String get discard => isBangla ? "বাতিল" : "Discard";
  String get cancel => isBangla ? "বাতিল" : "Cancel";
  String get done => isBangla ? "সম্পন্ন" : "Done";
  String get submit => isBangla ? "জমা দিন" : "Submit";
  String get pleaseWait => isBangla ? "অনুগ্রহ করে অপেক্ষা করুন..." : "Please wait...";

  // -------------------------------------------------------------
  // Profile Card & Official Details
  // -------------------------------------------------------------
  String get profileNameMp => isBangla ? "ব্যারিস্টার কায়সার কামাল, এমপি" : "Barrister Kayser Kamal, MP";
  String get profileConstituency => isBangla ? "নেত্রকোনা-১ (দুর্গাপুর-কলমাকান্দা)" : "Netrokona-1 (Durgapur-Kalmakanda)";
  String get profileDeputySpeaker => isBangla ? "ডেপুটি স্পিকার" : "Deputy Speaker";
  String get profileParliament => isBangla ? "বাংলাদেশ জাতীয় সংসদ" : "Bangladesh Parliament";
  String get profileMobileLabel => isBangla ? "মোবাইলঃ" : "Mobile:";
  String get profileMobileNumber => isBangla ? "০১৭১৩০৪৬৭৮৩" : "01713046783";
  String get profileEmailLabel => isBangla ? "ইমেইলঃ" : "Email:";
  String get profileEmailAddress => "netrokona.1@parliament.gov.bd";

  // -------------------------------------------------------------
  // Navigation & Drawer
  // -------------------------------------------------------------
  String get navHome => isBangla ? "হোম" : "Home";
  String get navAppointment => isBangla ? "সাক্ষাৎকার" : "Appointment";
  String get navComplaint => isBangla ? "অভিযোগ" : "Complaint";
  String get navContact => isBangla ? "যোগাযোগ" : "Contact";
  String get navProfile => isBangla ? "প্রোফাইল" : "Profile";

  String get menuAboutUs => isBangla ? "আমাদের সম্পর্কে" : "About Us";
  String get menuAboutMe => isBangla ? "আমার সম্পর্কে" : "About Me";
  String get menuBiography => isBangla ? "জীবনবৃত্তান্ত" : "Biography";
  String get menuHistory => isBangla ? "জীবন ও সংগ্রাম" : "History";
  String get menuHistoryOfLifeAndStruggle => isBangla ? "জীবন ও সংগ্রামের ইতিহাস" : "History of Life and Struggle";
  String get menuAchievement => isBangla ? "অর্জন" : "Achievement";
  String get menuJourney => isBangla ? "যাত্রা ও পথচলা" : "Journey";
  String get menuPhotoGallery => isBangla ? "ফটো গ্যালারি" : "Photo Gallery";
  String get menuVideoGallery => isBangla ? "ভিডিও গ্যালারি" : "Video Gallery";
  String get menuNews => isBangla ? "সংবাদ" : "News";
  String get menuBlog => isBangla ? "ব্লগ" : "Blog";
  String get menuPrintMedia => isBangla ? "প্রিন্ট মিডিয়া" : "Print Media";
  String get menuElectronicMedia => isBangla ? "ইলেকট্রনিক মিডিয়া" : "Electronic Media";
  String get menuDurgapur => isBangla ? "দুর্গাপুর উপজেলা" : "Durgapur Upazila";
  String get menuKalmakanda => isBangla ? "কলমাকান্দা উপজেলা" : "Kalmakanda Upazila";
  String get menuOtherDevWorks => isBangla ? "অন্যান্য উদ্যোগ" : "Other Initiatives";

  // -------------------------------------------------------------
  // Home Screen Widgets
  // -------------------------------------------------------------
  String get appointmentCardTitle => isBangla ? "সাক্ষাৎকারের অনুরোধ" : "Get An Appointment";
  String get appointmentCardSubtitle => isBangla
      ? "আপনার সুবিধাজনক সময়ে সরাসরি সাক্ষাতের জন্য ফর্মটি পূরণ করে অনুরোধ জানান।"
      : "Schedule an in-person appointment or meeting by submitting this form.";
  String get bookAppointmentBtn => isBangla ? "অনুরোধ পাঠান" : "Book Appointment";

  String get complaintCardTitle => isBangla ? "নাগরিক অভিযোগ বক্স" : "Citizen Complaint Box";
  String get complaintCardSubtitle => isBangla
      ? "আপনার এলাকা ও নাগরিক সমস্যা সম্পর্কে সরাসরি ব্যারিস্টার কায়সার কামালকে জানান।"
      : "Submit your complaints, local grievances, or public feedback directly.";
  String get submitComplaintBtn => isBangla ? "অভিযোগ দাখিল করুন" : "Submit Complaint";

  String get defaultAddress => isBangla
      ? "বাংলাদেশ জাতীয় সংসদ, শের-ই-বাংলা নগর, ঢাকা-১২০৭"
      : "Bangladesh Parliament, Sher-e-Bangla Nagar, Dhaka-1207";
  String get viewOnGoogleMaps => isBangla ? "গুগল ম্যাপে দেখুন" : "View on Google Maps";

  String get profileDesignation => isBangla
      ? "ডেপুটি স্পিকার\nবাংলাদেশ জাতীয় সংসদ\nনেত্রকোনা-১ (দুর্গাপুর-কলমাকান্দা)"
      : "Deputy Speaker\nBangladesh Parliament\nNetrokona-1 (Durgapur-Kalmakanda)";
  String get importantLinks => isBangla ? "গুরুত্বপূর্ণ লিংকসমূহ" : "Important Links";
  String get facebookPage => isBangla ? "ফেসবুক পেইজ" : "Facebook Page";
  String get followUs => isBangla ? "অনুসরণ করুন" : "Follow";
  String get copyrightText => isBangla
      ? "কপিরাইট © ২০২৬ ব্যারিস্টার কায়সার কামাল, এমপি। সর্বস্বত্ব সংরক্ষিত।"
      : "Copyright © 2026 Barrister Kayser Kamal, MP. All rights reserved.";

  // -------------------------------------------------------------
  // Biography, Journey, History & Achievements
  // -------------------------------------------------------------
  String get biographyTitle => isBangla ? "জীবনী" : "Biography";
  String get biographySubtitle => isBangla
      ? "ব্যারিস্টার কায়সার কামালের জীবন, শিক্ষা, আইন পেশা ও রাজনৈতিক সংগ্রামের তথ্য।"
      : "Life, education, legal career, and political journey of Barrister Kayser Kamal.";
  String get biographyEmpty => isBangla ? "জীবনী সংক্রান্ত কোনো তথ্য পাওয়া যায়নি" : "No biography content available";

  String get aboutMeTitle => isBangla ? "আমার সম্পর্কে" : "About Me";
  String get aboutMeSubtitle => isBangla
      ? "ব্যারিস্টার কায়সার কামালের প্রাথমিক জীবন, শিক্ষা এবং কর্মজীবনের ভূমিকা।"
      : "An introduction to Barrister Kayser Kamal's early life, vision, and legal career.";

  String get lifeHistoryTitle => isBangla ? "জীবন ও সংগ্রাম" : "History of Life";
  String get lifeHistorySubtitle => isBangla
      ? "গণতন্ত্র পুনরুদ্ধার, মানবাধিকার প্রতিষ্ঠা ও জনগণের অধিকার আদায়ের সংগ্রামের ইতিহাস।"
      : "The relentless struggle for democracy, human rights, and the rule of law.";
  String get lifeHistoryEmpty => isBangla ? "কোনো জীবনবৃত্তান্ত পাওয়া যায়নি" : "No life history records found";

  String get achievementTitle => isBangla ? "অর্জন ও সম্মাননা" : "Achievements";
  String get achievementSubtitle => isBangla
      ? "আইন পেশা, সমাজসেবা এবং জাতীয় রাজনীতিতে ব্যারিস্টার কায়সার কামালের গুরুত্বপূর্ণ অর্জনসমূহ।"
      : "Major accomplishments, leadership milestones, and legal contributions.";

  String get journeyTitle => isBangla ? "যাত্রা ও পথচলা" : "Journey & Milestones";
  String get journeySubtitle => isBangla
      ? "শিক্ষাজীবন থেকে জাতীয় রাজনীতি ও সুপ্রিম কোর্ট বার অ্যাসোসিয়েশন পর্যন্ত বর্ণাঢ্য পথচলা।"
      : "The timeline and evolution of a distinguished legal and political career.";

  // -------------------------------------------------------------
  // Media & News
  // -------------------------------------------------------------
  String get newsTitle => isBangla ? "সংবাদ ও আপডেট" : "News & Updates";
  String get newsSubtitle => isBangla
      ? "সর্বশেষ খবর, রাজনৈতিক বিবৃতি এবং জনকল্যাণমূলক কর্মকাণ্ডের নিয়মিত আপডেট।"
      : "Latest news, political statements, and official updates.";
  String get newsDetailsTitle => isBangla ? "সংবাদের বিস্তারিত" : "News Details";
  String get newsEmpty => isBangla ? "কোনো সংবাদ পাওয়া যায়নি" : "No news articles found";

  String get blogTitle => isBangla ? "ব্লগ ও মতামত" : "Blog & Articles";
  String get blogSubtitle => isBangla
      ? "আইন, মানবাধিকার, গণতন্ত্র ও সাম্প্রতিক ঘটনাবলী নিয়ে গুরুত্বপূর্ণ কলাম ও মতামত।"
      : "Opinion pieces, analysis, and columns on law, human rights, and governance.";
  String get blogEmpty => isBangla ? "কোনো ব্লগ পোস্ট পাওয়া যায়নি" : "No blog posts available";

  String get photoGalleryTitle => isBangla ? "ফটো গ্যালারি" : "Photo Gallery";
  String get photoGallerySubtitle => isBangla
      ? "রাজনৈতিক কর্মসূচি, সামাজিক কর্মকাণ্ড ও জনসভার দুর্লভ ও সাম্প্রতিক আলোকচিত্র।"
      : "Photographs from public rallies, party events, and social initiatives.";
  String get photoEmpty => isBangla ? "কোনো ছবি পাওয়া যায়নি" : "No photos available";
  String get photoAlbumSubtitle => isBangla
      ? "ব্যারিস্টার কায়সার কামালের রাজনৈতিক ও সামাজিক কার্যক্রমের আলোকচিত্র।"
      : "High-resolution photos from official activities and public gatherings.";
  String get photoAlbumEmpty => isBangla ? "এই অ্যালবামে এখনও কোনো ছবি আপলোড করা হয়নি।" : "No photos uploaded to this album yet.";

  String get videoGalleryTitle => isBangla ? "ভিডিও গ্যালারি" : "Video Gallery";
  String get videoGallerySubtitle => isBangla
      ? "বক্তব্য, টেলিভিশন টকশো, সাক্ষাৎকার এবং বিভিন্ন জনসভার গুরুত্বপূর্ণ ভিডিও।"
      : "Speeches, televised interviews, talk shows, and public addresses.";
  String get videoEmpty => isBangla ? "কোনো ভিডিও পাওয়া যায়নি" : "No videos available";

  String get printMediaTitle => isBangla ? "প্রিন্ট মিডিয়া" : "Print Media";
  String get printMediaSubtitle => isBangla
      ? "জাতীয় ও আঞ্চলিক দৈনিক সংবাদপত্রে প্রকাশিত সংবাদ, কলাম এবং সাক্ষাৎকার।"
      : "Articles, interviews, and press coverages published in national print media.";
  String get printMediaEmpty => isBangla ? "প্রিন্ট মিডিয়ার কোনো সংবাদ পাওয়া যায়নি" : "No print media coverage found";

  String get electronicMediaTitle => isBangla ? "ইলেকট্রনিক মিডিয়া" : "Electronic Media";
  String get electronicMediaSubtitle => isBangla
      ? "টেলিভিশন নিউজ, টকশো এবং ইলেকট্রনিক সম্প্রচার মাধ্যমের বিশেষ প্রতিবেদনসমূহ।"
      : "Broadcast coverages, TV talk shows, and electronic news features.";
  String get electronicMediaEmpty => isBangla ? "ইলেকট্রনিক মিডিয়ার কোনো প্রতিবেদন পাওয়া যায়নি" : "No electronic media reports found";

  // -------------------------------------------------------------
  // Development Works
  // -------------------------------------------------------------
  String get durgapurTitle => isBangla ? "দুর্গাপুর উপজেলা" : "Durgapur Upazila";
  String get durgapurSubtitle => isBangla
      ? "দুর্গাপুর উপজেলার অবকাঠামো উন্নয়ন, প্রকল্প এবং জনকল্যাণমূলক কার্যক্রম।"
      : "Development works, infrastructure projects, and public welfare initiatives in Durgapur.";
  String get durgapurEmpty => isBangla ? "কোন উন্নয়নমূলক কাজের তথ্য পাওয়া যায়নি" : "No development works listed yet";

  String get kalmakandaTitle => isBangla ? "কলমাকান্দা উপজেলা" : "Kalmakanda Upazila";
  String get kalmakandaSubtitle => isBangla
      ? "কলমাকান্দা উপজেলার অবকাঠামো উন্নয়ন, প্রকল্প এবং জনকল্যাণমূলক কার্যক্রম।"
      : "Development works, infrastructure projects, and public welfare initiatives in Kalmakanda.";
  String get kalmakandaEmpty => isBangla ? "কোন উন্নয়নমূলক কাজের তথ্য পাওয়া যায়নি" : "No development works listed yet";

  String get othersDevTitle => isBangla ? "অন্যান্য উদ্যোগ" : "Other Initiatives";
  String get othersDevSubtitle => isBangla
      ? "উন্নয়নমূলক কর্মকাণ্ড ও জনকল্যাণমূলক উদ্যোগের বিস্তারিত তথ্য ও কার্যক্রম।"
      : "Detailed information and activities of development work and public welfare initiatives.";
  String get othersDevEmpty => isBangla ? "অন্যান্য কোন উন্নয়নমূলক কাজের তথ্য পাওয়া যায়নি" : "No other development works listed yet";

  // -------------------------------------------------------------
  // Forms & User Inputs
  // -------------------------------------------------------------
  String get contactScreenTitle => isBangla ? "যোগাযোগ করুন" : "Contact Us";
  String get contactScreenSubtitle => isBangla
      ? "যেকোনো পরামর্শ, অভিযোগ বা সহযোগিতার জন্য সরাসরি আমাদের সাথে যোগাযোগ করুন।"
      : "Get in touch with our office for legal inquiries, constituency issues, or appointments.";
  String get officialContactInfo => isBangla ? "অফিসিয়াল যোগাযোগের ঠিকানা" : "Official Contact Info";
  String get headOffice => isBangla ? "প্রধান কার্যালয়" : "Head Office";
  String get phone => isBangla ? "ফোন" : "Phone";
  String get email => isBangla ? "ইমেইল" : "Email";
  String get sendDirectMessage => isBangla ? "সরাসরি বার্তা পাঠান" : "Send Us a Direct Message";

  String get fullNameLabel => isBangla ? "পূর্ণ নাম *" : "Full Name *";
  String get fullNameHint => isBangla ? "আপনার পূর্ণ নাম লিখুন" : "Enter your full name";
  String get fullNameRequired => isBangla ? "নামের ঘরটি পূরণ করা আবশ্যক" : "Name is required";

  String get phoneLabel => isBangla ? "ফোন নম্বর *" : "Phone Number *";
  String get phoneHint => isBangla ? "যেমন: ০১৭১২-৩৪৫৬৭৮" : "e.g. 01700000000";
  String get phoneRequired => isBangla ? "ফোন নম্বর আবশ্যক" : "Phone number is required";

  String get mobileLabel => isBangla ? "মোবাইল নম্বর *" : "Mobile Number *";
  String get mobileHint => isBangla ? "যেমন: ০১৭১২-৩৪৫৬৭৮" : "e.g. 01700000000";
  String get mobileRequired => isBangla ? "মোবাইল নম্বর আবশ্যক" : "Mobile number is required";

  String get emailLabel => isBangla ? "ইমেইল ঠিকানা" : "Email Address";
  String get emailOptionalLabel => isBangla ? "ইমেইল (ঐচ্ছিক)" : "Email (Optional)";
  String get emailHint => "e.g. user@example.com";
  String get emailRequired => isBangla ? "ইমেইল আবশ্যক" : "Email is required";

  String get citizenTypeLabel => isBangla ? "নাগরিকের ধরন *" : "Citizen Type *";
  String get citizenLocal => isBangla ? "স্থানীয়" : "Local";
  String get citizenForeignNrb => isBangla ? "প্রবাসী / এনআরবি" : "Foreign / NRB";

  String get personalInfoSection => isBangla ? "ব্যক্তিগত তথ্য" : "Personal Information";
  String get addressDetailsSection => isBangla ? "ঠিকানার বিবরণ" : "Address Details";
  String get divisionLabel => isBangla ? "বিভাগ *" : "Division *";
  String get divisionHint => isBangla ? "বিভাগ নির্বাচন করুন" : "Select Division";
  String get districtLabel => isBangla ? "জেলা *" : "District *";
  String get districtHint => isBangla ? "জেলা নির্বাচন করুন" : "Select District";
  String get selectDivisionFirst => isBangla ? "আগে বিভাগ নির্বাচন করুন" : "Select Division first";
  String get upazilaLabel => isBangla ? "উপজেলা *" : "Upazila *";
  String get upazilaHint => isBangla ? "উপজেলা নির্বাচন করুন" : "Select Upazila";
  String get selectDistrictFirst => isBangla ? "আগে জেলা নির্বাচন করুন" : "Select District first";
  String get unionLabel => isBangla ? "ইউনিয়ন / পৌরসভা *" : "Union / Pourashava *";
  String get unionHint => isBangla ? "ইউনিয়ন নির্বাচন করুন" : "Select Union";
  String get selectUpazilaFirst => isBangla ? "আগে উপজেলা নির্বাচন করুন" : "Select Upazila first";

  String get wardLabel => isBangla ? "ওয়ার্ড নম্বর (ঐচ্ছিক)" : "Ward Number (Optional)";
  String get wardHint => isBangla ? "যেমন: ৩" : "e.g. 3";
  String get villageLabel => isBangla ? "গ্রাম / মহল্লা (ঐচ্ছিক)" : "Village / Mohallah (Optional)";
  String get villageHint => isBangla ? "যেমন: নবীনগর" : "e.g. Nabinagar";

  String get appointmentDetailsSection => isBangla ? "সাক্ষাৎকারের বিবরণ" : "Appointment Details";
  String get appointmentDateLabel => isBangla ? "সাক্ষাতের সম্ভাব্য তারিখ *" : "Preferred Appointment Date *";
  String get appointmentDateHint => isBangla ? "YYYY-MM-DD নির্বাচন করুন" : "YYYY-MM-DD";
  String get appointmentDateRequired => isBangla ? "তারিখ নির্বাচন করা আবশ্যক" : "Date is required";

  String get appointmentSubjectLabel => isBangla ? "সাক্ষাতের বিষয় *" : "Appointment Subject *";
  String get appointmentSubjectHint => isBangla ? "যেমন: এলাকা ও নাগরিক সংক্রান্ত আলোচনা" : "e.g. Constitutional advisory meeting";
  String get appointmentSubjectRequired => isBangla ? "বিষয় উল্লেখ করা আবশ্যক" : "Subject is required";

  String get appointmentMessageLabel => isBangla ? "সাক্ষাতের উদ্দেশ্য / বিবরণ *" : "Meeting Purpose / Details *";
  String get appointmentMessageHint => isBangla ? "সাক্ষাতের উদ্দেশ্য ও আলোচনার বিষয় বিস্তারিত লিখুন..." : "Explain the reason and agenda for requesting the appointment...";
  String get appointmentMessageRequired => isBangla ? "বিস্তারিত বিবরণ দেওয়া আবশ্যক" : "Details are required";

  String get complaintDetailsSection => isBangla ? "অভিযোগের বিবরণ" : "Complaint Message";
  String get complaintSubjectLabel => isBangla ? "বিষয় (ঐচ্ছিক)" : "Subject (Optional)";
  String get complaintSubjectHint => isBangla ? "যেমন: রাস্তা সংস্কার প্রসঙ্গে" : "e.g. Road repair";
  String get complaintMessageLabel => isBangla ? "অভিযোগের বিস্তারিত *" : "Complaint Details *";
  String get complaintMessageHint => isBangla ? "আপনার সমস্যা বা অভিযোগটি বিস্তারিত লিখুন..." : "Describe your issue or grievance in detail...";
  String get complaintMessageRequired => isBangla ? "অভিযোগের বিস্তারিত বিবরণ দেওয়া আবশ্যক" : "Message is required";

  String get messageLabel => isBangla ? "বার্তা *" : "Message *";
  String get messageHint => isBangla ? "আপনার বার্তা এখানে লিখুন..." : "Write your message here...";
  String get messageRequired => isBangla ? "বার্তা আবশ্যক" : "Message is required";
  String get sendMessageBtn => isBangla ? "বার্তা পাঠান" : "Send Message";
  String get messageSentSuccess => isBangla ? "আপনার বার্তা সফলভাবে পাঠানো হয়েছে!" : "Your message has been sent successfully!";

  String get addressLabel => isBangla ? "ঠিকানা" : "Address";
  String get parliamentAddress => isBangla ? "বাংলাদেশ জাতীয় সংসদ ভবন, ঢাকা" : "Bangladesh Parliament Building, Dhaka";
  String get yourNameLabel => isBangla ? "আপনার নাম *" : "Your Name *";
  String get nameRequired => isBangla ? "নাম আবশ্যক" : "Name is required";
  String get phoneNumberLabel => isBangla ? "ফোন নম্বর" : "Phone Number";
  String get subjectLabel => isBangla ? "বিষয় *" : "Subject *";
  String get subjectRequired => isBangla ? "বিষয় আবশ্যক" : "Subject is required";

  String get appointmentBannerTitle => isBangla ? "সাক্ষাৎকারের অনুরোধ" : "Get An Appointment";
  String get appointmentBannerSubtitle => isBangla
      ? "সাক্ষাৎকারের অনুরোধ জানাতে নিচের ফরমটি পূরণ করুন। সঠিক তথ্য প্রদান করে সহযোগিতা করুন।"
      : "Fill out the form below to request an appointment. Provide accurate information so we can assist you efficiently.";
  String get appointmentRequestedTitle => isBangla ? "সাক্ষাৎকারের অনুরোধ সফল" : "Appointment Requested";
  String get appointmentRequestedMessage => isBangla
      ? "আপনার সাক্ষাতের অনুরোধটি সফলভাবে জমা হয়েছে। আপনার ট্র্যাকিং নম্বরটি সংরক্ষণ করুন:"
      : "Your appointment request has been submitted successfully. Please save your tracking number:";

  String get complainBannerTitle => isBangla ? "নাগরিক অভিযোগ" : "Citizen Complaint";
  String get complainBannerSubtitle => isBangla
      ? "নিচের ফরম ব্যবহার করে সরাসরি আপনার অভিযোগ, মতামত বা গুরুত্বপূর্ণ তথ্য জানান।"
      : "Submit your complaint, feedback, or important information directly using the form below.";
  String get complaintSubmittedTitle => isBangla ? "অভিযোগ দাখিল সফল" : "Complaint Submitted";
  String get complaintSubmittedMessage => isBangla
      ? "আপনার অভিযোগটি সফলভাবে জমা হয়েছে। আপনার ট্র্যাকিং নম্বরটি সংরক্ষণ করুন:"
      : "Your complaint has been registered successfully. Please keep your tracking number for future updates:";

  String get trackingCopied => isBangla ? "ট্র্যাকিং নম্বর কপি করা হয়েছে!" : "Tracking number copied!";
  String get discardBtn => isBangla ? "বাতিল" : "Discard";
  String get selectLocationError => isBangla
      ? "দয়া করে বিভাগ, জেলা, উপজেলা এবং ইউনিয়ন নির্বাচন করুন"
      : "Please select Division, District, Upazila, and Union";
  String get selectDateError => isBangla ? "দয়া করে সাক্ষাতের তারিখ নির্বাচন করুন" : "Please select appointment date";
  String get loadDivisionsError => isBangla ? "বিভাগ লোড হতে ব্যর্থ হয়েছে" : "Failed to load divisions";
  String get loadDistrictsError => isBangla ? "জেলা লোড হতে ব্যর্থ হয়েছে" : "Failed to load districts";
  String get loadUpazilasError => isBangla ? "উপজেলা লোড হতে ব্যর্থ হয়েছে" : "Failed to load upazilas";
  String get loadUnionsError => isBangla ? "ইউনিয়ন লোড হতে ব্যর্থ হয়েছে" : "Failed to load unions";

  // -------------------------------------------------------------
  // Account & Profile
  // -------------------------------------------------------------
  String get myAccount => isBangla ? "আমার অ্যাকাউন্ট" : "My Account";
  String get welcomeApp => isBangla ? "কায়সার কামাল অ্যাপে স্বাগতম" : "Welcome to Kayser Kamal App";
  String get welcomeAppSubtitle => isBangla
      ? "আপনার অভিযোগ ও সাক্ষাৎকারের তথ্য দেখতে এবং প্রোফাইল পরিচালনা করতে সাইন ইন করুন।"
      : "Sign in or create an account to track your complaints, book appointments, and manage profile settings.";
  String get signIn => isBangla ? "সাইন ইন করুন" : "Sign In";
  String get registerNewAccount => isBangla ? "নতুন অ্যাকাউন্ট খুলুন" : "Register New Account";
  String get complaintBoxSubtitle => isBangla ? "আপনার অভিযোগ ও মতামত জানান" : "Submit grievances or local issues";
  String get appointmentRequestTitle => isBangla ? "সাক্ষাৎকার ও মিটিং অনুরোধ" : "Appointment & Meeting Request";
  String get appointmentRequestSubtitle => isBangla ? "সাক্ষাতের জন্য অনুরোধ পাঠান" : "Schedule an in-person meeting";
  String get signOut => isBangla ? "লগআউট" : "Sign Out";
  String get signOutSubtitle => isBangla ? "অ্যাকাউন্ট থেকে সাইন আউট করুন" : "Log out from your account";
  String get signOutConfirmTitle => isBangla ? "সাইন আউট" : "Sign Out";
  String get signOutConfirmMessage => isBangla ? "আপনি কি নিশ্চিত যে সাইন আউট করতে চান?" : "Are you sure you want to sign out?";

  // -------------------------------------------------------------
  // Dynamic String Translation Lookup (Key-based)
  // -------------------------------------------------------------
  static String tr(String key, bool isBangla) {
    final map = isBangla ? _bnMap : _enMap;
    return map[key] ?? key;
  }

  static const Map<String, String> _bnMap = {
    'app_title': "ব্যারিস্টার কায়সার কামাল",
    'today_visitor': "আজকের ভিজিটর",
    'total_visitor': "মোট ভিজিটর",
    'read_more': "বিস্তারিত পড়ুন",
    'discard': "বাতিল",
    'submit': "জমা দিন",
  };

  static const Map<String, String> _enMap = {
    'app_title': "Barrister Kayser Kamal",
    'today_visitor': "Today Visitor",
    'total_visitor': "Total Visitor",
    'read_more': "Read More",
    'discard': "Discard",
    'submit': "Submit",
  };
}

final appTranslationsProvider = Provider<AppTranslations>((ref) {
  final isBangla = ref.watch(isBanglaProvider);
  return AppTranslations.of(isBangla);
});
