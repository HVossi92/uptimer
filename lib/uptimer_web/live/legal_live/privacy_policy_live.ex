defmodule UptimerWeb.Legal.PrivacyPolicyLive do
  use UptimerWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8 max-w-4xl">
      <div class="bg-white dark:bg-gray-800 shadow-md rounded-lg p-6 sm:p-8">
        <h1 class="text-3xl font-bold text-gray-900 dark:text-gray-100 mb-6">Privacy Policy</h1>

        <div class="prose dark:prose-invert max-w-none">
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Last updated: {Date.utc_today() |> Date.to_string()}
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            1. Introduction
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Welcome to Uptimer ("we," "our," or "us"). We are committed to protecting your privacy and handling your data with transparency. This Privacy Policy explains how we collect, use, and safeguard your information when you use our website monitoring service.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            2. Information We Collect
          </h2>

          <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200 mt-4 mb-2">
            2.1 Personal Information
          </h3>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We collect the following personal information when you register and use our service:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>Email address</li>
            <li>Account credentials (password is stored in encrypted form)</li>
            <li>Website URLs you add for monitoring</li>
          </ul>

          <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200 mt-4 mb-2">
            2.2 Automatically Collected Information
          </h3>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We collect minimal technical information when you use our service, limited to:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>IP address (for security purposes only)</li>
            <li>Basic system information required for the service to function</li>
            <li>Session data required to keep you logged in</li>
          </ul>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We do not use analytics tools, tracking pixels, or other technologies to monitor your behavior or collect usage statistics beyond what is strictly necessary for providing our service.
          </p>

          <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200 mt-4 mb-2">
            2.3 Website Thumbnails
          </h3>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            As part of our monitoring service, we generate and store thumbnails of the websites you add. These thumbnails are visual representations of how your websites appear at the time of monitoring and are only accessible to you.
          </p>

          <h3 class="text-lg font-medium text-gray-800 dark:text-gray-200 mt-4 mb-2">
            2.4 Embedded Content and iFrames
          </h3>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Our service may display your monitored websites within iframes. Please be aware that:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>
              Content displayed within these iframes is hosted and controlled by third parties (the websites you are monitoring)
            </li>
            <li>
              These third-party websites may use their own cookies, web beacons, and similar technologies
            </li>
            <li>They may collect their own data about you and your online activities</li>
            <li>They are governed by their own privacy policies and terms of service</li>
          </ul>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            <strong>Important:</strong>
            We are not responsible in any way, shape, or form for the data, files, cookies, or other content that might come from websites embedded in iframes as part of our monitoring service. We have no influence over or control of the content, behavior, or data collection practices of these embedded websites.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            3. How We Use Your Information
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We use your information for the following purposes:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>To provide and maintain our service</li>
            <li>To notify you about the status of your monitored websites</li>
            <li>To respond to your requests and inquiries</li>
            <li>To improve our service and develop new features</li>
            <li>To detect, prevent, and address technical issues</li>
            <li>To comply with legal obligations</li>
          </ul>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            4. Legal Basis for Processing (EU Users)
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            For users in the European Union, we process your personal data based on the following legal grounds:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>
              <strong>Contract fulfillment:</strong>
              Processing necessary to provide our service to you
            </li>
            <li>
              <strong>Legitimate interests:</strong>
              Improving our services, ensuring security, and preventing fraud
            </li>
            <li>
              <strong>Consent:</strong>
              For specific processing activities where we request your consent
            </li>
            <li><strong>Legal obligation:</strong> When we need to comply with applicable laws</li>
          </ul>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            5. Data Retention
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We retain your personal information only for as long as necessary to fulfill the purposes outlined in this Privacy Policy, including to provide our service, comply with legal obligations, resolve disputes, and enforce our agreements.
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Website thumbnails are retained for as long as you maintain an active account and have enabled thumbnail monitoring for your websites. When you delete a website from your account, we will automatically and directly delete the associated thumbnails.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            6. Your Data Protection Rights
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Depending on your location, you may have the following rights regarding your personal data:
          </p>
          <ul class="list-disc pl-6 mb-4 text-gray-700 dark:text-gray-300">
            <li>
              <strong>Access:</strong> You have the right to request copies of your personal data.
            </li>
            <li>
              <strong>Rectification:</strong>
              You have the right to request that we correct inaccurate information.
            </li>
            <li>
              <strong>Erasure:</strong>
              You have the right to request that we delete your data under certain conditions.
            </li>
            <li>
              <strong>Restriction:</strong>
              You have the right to request that we restrict the processing of your data.
            </li>
            <li>
              <strong>Data portability:</strong>
              You have the right to request that we transfer your data to another organization or directly to you.
            </li>
            <li>
              <strong>Objection:</strong>
              You have the right to object to our processing of your personal data.
            </li>
          </ul>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            To exercise any of these rights, please contact us using the details provided in the "Contact Us" section.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            7. Cookies and Similar Technologies
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We use only essential cookies for maintaining your login session. We do not use any tracking cookies, analytics cookies, or any other cookies that would track your behavior or activities on our service.
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            The session cookie is necessary for the proper functioning of our service, specifically to keep you logged in while you navigate through our website. This cookie contains only a session identifier and does not store any personal information.
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            No third-party cookies are used, and we do not perform any kind of tracking or monitoring of your browsing activity beyond what is strictly necessary to provide our service.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            8. Data Security
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We implement appropriate technical and organizational measures to protect your personal data against unauthorized or unlawful processing, accidental loss, destruction, or damage. However, no method of transmission over the Internet or electronic storage is 100% secure, and we cannot guarantee absolute security.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            9. International Data Transfers
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Your information may be transferred to and maintained on servers located outside of your country or jurisdiction. We will take all steps reasonably necessary to ensure that your data is treated securely and in accordance with this Privacy Policy, and no transfer of your personal data will take place to an organization or a country unless there are adequate controls in place.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            10. Children's Privacy
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            Our service is not intended for use by individuals under the age of 18. We do not knowingly collect personal information from children under 18. If we discover that a child under 18 has provided us with personal information, we will immediately delete it.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            11. Changes to This Privacy Policy
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date at the top of this policy. You are advised to review this Privacy Policy periodically for any changes.
          </p>

          <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-200 mt-6 mb-3">
            12. Contact Us
          </h2>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            If you have any questions about this Privacy Policy, please contact us at:
          </p>
          <p class="text-gray-700 dark:text-gray-300 mb-4">
            <a
              href="mailto:privacy@uptimer.example.com"
              class="text-blue-600 dark:text-blue-400 hover:underline"
            >
              hendrik.vosskamp@gmail.com
            </a>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
