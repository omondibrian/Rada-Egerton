class ContactsAndLocationProvider {
  getContacts() {
    //TODO:Add actual api response
    return [
      {
        'title': 'Main Campus',
        'phoneNumber': '+25476365537',
        'email': 'egerton@gmail.com',
        'location': 'Njoro'
      },
      {
        'title': 'Nakuru Campus',
        'phoneNumber': '+25476365537',
        'email': 'egerton@gmail.com',
        'location': 'Nakuru'
      },
    ];
  }

  getLocation() {
    return [];
    //TODO ; Fix this location display issue
    //TODO : study GeoLocator flutter library
  }
}
