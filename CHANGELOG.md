# ***MyDiscoveries***
## ** Unreleased **
### Bugs Fixed
### New Features
- Add admin-only add_on flag to Add Ons
- Validity dates are now shoing in itinerary (content will most likely need updating)
- Added operating schedule to itinerary
- Replaced "Created At" with "Purchase Date" on all orders screen
- Added PaperTrail to Orders, Products, Variants, Line Items, Add Ons
- Purchase date on All Orders page is now localised (when possible)
- Competition partial is now fixed
- Information for voucher is now in one column

## **18/09/2017**
### Bugs Fixed
- Fixed a bug where you could not properly look up Operators through Offers (database only)
### New Features
- Variants for SNA Yangtze have been scripted in
- Variants for SNA Yangtze + Beijing have been scripted in
- Variants for SNA India have been scripted in
- Supplier Product Codes for SNA Yangtze have been scripted in
- Supplier Product Codes for SNA Yangtze + Beijing have been scripted in
- Supplier Product Codes for SNA India have been scripted in
- Add-ons now display on voucher
- If customer has no email and order has an SNA product, email is sent to "noemail@snatours.com"
- Departure Date can now be modified after purchase by admin users
- Orders are now marked "Sent To SNA" true or false
- Orders can now be manually sent to SNA API (via a button)
- Confirmation emails can now be manually re-sent on the "edit departure date" screen
- Orders that contain SNA products that have departure dates are now no longer automatically sent to SNA API
- Added ability to create new variants via Excel import
- Departure dates on product form are sorted chronologically
- If variant has a departure date > the year 2049, it will display "I don't know yet" on the departure date picker on the product page
- Added a button to update order total in shopping cart (so user can update price after choosing add-on)


## **12/09/2017**
### New Features
- Added a "Reset Options" button to product pages

## **12/09/2017**
### Bugs Fixed
- Fixed minor layout bug in pdf voucher
- Removed duplicate "Travel Stories" menu item on mobile layout

## **29/08/2017**
### Bugs Fixed
- Fix installment flag on order_info page to show correct request_installments
- Fix titleize error for Customer full_name method

## **28/08/2017**
### Bugs Fixed
- "Landing" forwarded URL's will now show a "404 Not Found" when the URL is destroyed.
 
## **22/08/2017**
### New Features
- Implement ability to update customer details attached to an order.
- Fix inconsistent font on confirmation/voucher page
- Customer Title (Mr, Mrs, etc.) now capitalised on voucher
- Competitions Card now centred on home page
### New Features
- "As Per Passport" copy added to passenger details form
- Voucher footer restyled
- Remove "Choose User" dropdown from new stories form. Story User defaults to current user.

## **16/08/2017**
### Bugs Fixed
- Removed Booking Essentials from Voucher
- Added Voucher Booking Essentials to Voucher
- Added Accommodation Option to Voucher

## **16/08/2017**
### New Features
- Added Traveller Feedback Survey to posts and link in footer

## **15/08/2017**
### Bugs Fixed
- Fixed strange color on hover of "download itinerary" link on confirmation page
### New Features
- New status of private available on Offers. Allow AX to process orders that are not live.

## **14/08/2017**
### New features
- Redesign of Voucher and PDF attachment / Download Itinerary
- Download Itinerary added back to products page ("Booking essentials for voucher" removed)

## ** 10/08/2017 **
### Bugs Fixed
- Fix customer_id on orders sent to Innovations AX

### New features
- New orders will be sent to HubSpot as "Deals"
- Home page competitions
- "Headlines" on product pages
- Offer type (related to HubSpot)